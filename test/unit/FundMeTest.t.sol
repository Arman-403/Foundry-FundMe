//SPDX-License-Identifier :MIT

pragma solidity ^0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;
    address USER = makeAddr("user");
    uint256 private constant SEND_VALUE = 0.1 ether;
    uint256 private constant INTIAL_BALANCE = 100 ether;

    modifier funded() {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        _;
    }

    function setUp() public {
        DeployFundMe DEPLOYER = new DeployFundMe();
        fundMe = DEPLOYER.run();
        vm.deal(USER, INTIAL_BALANCE);
    }

    function testMinUsd() public view {
        assert(fundMe.getMinUsd() >= 5e18);
        // console.log(((fundMe.getMinUsd) / 1e18));
    }

    function testWhoIsOwner() public view {
        assertEq(fundMe.getOwner(), msg.sender);

        console.log(fundMe.getOwner());
    }

    function testVersion() public view {
        assertEq(fundMe.getVersion(), 4);
        // console.log(fundMe.getVersion());
    }

    function testFundFailWithoutEnoughEth() public funded {
        // vm.prank(USER);
        vm.expectRevert();
        fundMe.fund();
    }

    function testAddFundersToArrayOfFunders() public funded {
        address funder = fundMe.getFunder(0);
        assertEq(funder, USER);
    }

    function testGetAllFunders() public funded {
        uint256 fundersLength = fundMe.getFundersArrayLength();

        for (uint256 i = 0; i < fundersLength; i++) {
            address _funder = fundMe.getFunder(i);

            console.log("Funders: ");
            console.log(_funder);
        }
        assertEq(fundersLength, 1, "Should be only one funder there");
    }

    function testOnlyOwnerCanWithdraw() public funded {
        vm.expectRevert();
        fundMe.withdraw();
    }

    function testWithdrawWithSingleOwner() public {
        // arrange
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingContractBalance = address(fundMe).balance;

        // act
        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();

        // assert
        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingContractBalance = address(fundMe).balance;

        assertEq(endingContractBalance, 0);
        assertEq(
            endingOwnerBalance,
            startingOwnerBalance + startingContractBalance
        );
    }

    function testWithdrawWithMultipleFunders() public funded {
        uint160 startingOfFunder = 1;
        uint160 totalNoOfFunders = 10;

        for (
            startingOfFunder = 1;
            startingOfFunder < totalNoOfFunders;
            startingOfFunder++
        ) {
            hoax(address(startingOfFunder), SEND_VALUE);
            fundMe.fund{value: SEND_VALUE}();
        }
        uint256 startingFundMeBalance = address(fundMe).balance;
        uint256 startingOwnerBalance = fundMe.getOwner().balance;

        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();

        uint256 endingFundMeBalance = address(fundMe).balance;
        uint256 endingOwnerBalance = fundMe.getOwner().balance;

        assertEq(endingFundMeBalance, 0);
        assertEq(
            endingOwnerBalance,
            startingFundMeBalance + startingOwnerBalance
        );
    }
}
