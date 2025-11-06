// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";
/*//////////////////////////////////////////////////////////////
                                ERRORS
//////////////////////////////////////////////////////////////*/

error FundMe__YOU_ARE_NOT_THE_OWNER();
error FundMe__WITHDRAW_FAILED();

contract FundMe {
    using PriceConverter for uint256;
    /*//////////////////////////////////////////////////////////////
                              STATE VARIABLES
    //////////////////////////////////////////////////////////////*/

    uint256 private constant MIN_USD = 5e18;

    address private immutable i_owner;

    address[] private s_funders;
    AggregatorV3Interface private s_priceFeed;
    mapping(address => uint256) private s_funderToAmountFunded;

    modifier OwnerOnly() {
        if (msg.sender != i_owner) {
            revert FundMe__YOU_ARE_NOT_THE_OWNER();
        }
        _;
    }

    constructor(address _priceFeed) {
        s_priceFeed = AggregatorV3Interface(_priceFeed);
        i_owner = msg.sender;
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }

    function fund() public payable {
        require(msg.value.getConversionRate(s_priceFeed) >= MIN_USD, "Send More Eth");
        s_funders.push(msg.sender);
        s_funderToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() external OwnerOnly {
        address[] memory funders = s_funders;
        for (uint256 i = 0; i < funders.length; i++) {
            s_funderToAmountFunded[funders[i]] = 0;
        }
        s_funders = new address[](0);

        (bool success,) = i_owner.call{value: address(this).balance}("");

        if (!success) {
            revert FundMe__WITHDRAW_FAILED();
        }
    }

    /*//////////////////////////////////////////////////////////////
                            GETTER FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    function getMinUsd() public pure returns (uint256) {
        return MIN_USD;
    }

    function getOwner() public view returns (address) {
        return i_owner;
    }

    function getPriceFeed() public view returns (address) {
        return address(s_priceFeed);
    }

    function getVersion() public view returns (uint256) {
        return s_priceFeed.version();
    }

    function getFunder(uint256 index) public view returns (address) {
        return s_funders[index];
    }
}
