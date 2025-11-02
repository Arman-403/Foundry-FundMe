//SPDX-License-Identifier :MIT

pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundMe} from "../../src/FundMe.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interaction.s.sol";

contract interactionTest is Test {
    FundMe public fundMe;
    uint256 public constant SEND_VALUE = 0.01 ether;
    uint256 public constant STARTING_BALANCE = 100 ether;

    function setUp() public {
        DeployFundMe deployer = new DeployFundMe();
        fundMe = deployer.run();
    }

    function testUserCanFundInteraction() public {
        FundFundMe fundFundMe = new FundFundMe();
        vm.deal(address(fundFundMe), STARTING_BALANCE);
        fundFundMe.fundFundMe(address(fundMe));

        address funder = fundMe.getFunder(0);
        assertEq(funder, address(fundFundMe));
    }

    function testUserCanWithdrawInteraction() public {
        FundFundMe fundFundMe = new FundFundMe();
        vm.deal(address(fundFundMe), STARTING_BALANCE);
        fundFundMe.fundFundMe(address(fundMe));

        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        withdrawFundMe.withdrawFundMe(address(fundMe));

        assert(address(fundMe).balance == 0);
    }
}
