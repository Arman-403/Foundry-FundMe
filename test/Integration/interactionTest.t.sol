//SPDX-License-Identifier :MIT

pragma solidity ^0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundMe} from "../../src/FundMe.sol";
import {MockV3Aggregator} from "../../test/mocks/MockV3Aggregator.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interaction.s.sol";
import {CodeConstants} from "../../script/HelperConfig.s.sol";

contract interactionTest is Test, CodeConstants {
    receive() external payable {}

    FundMe public fundMe;
    bool public isCI;

    function setUp() public {
        isCI = vm.envOr("CI", false);

        if (isCI) {
            // Deploy mock setup for CI
            MockV3Aggregator mockV3Aggregator = new MockV3Aggregator(DECIMALS, INITIAL_PRICE);
            fundMe = new FundMe(address(mockV3Aggregator));
            console.log("Recent Mock Price Feed address for CI", address(mockV3Aggregator));
            console.log("Running on CI : Deployed FundMe with mock ");
            // In CI, test contract (this) should be the owner since we deployed directly
            assertEq(fundMe.getOwner(), address(this));
        } else {
            // normal deployer for local development
            DeployFundMe deployer = new DeployFundMe();
            fundMe = deployer.run();
            console.log("Running Locally: using DeployFundMe script");
            // Log the owner address to help debug ownership in local runs
            console.log("FundMe owner address:", fundMe.getOwner());
        }
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

        console.log("fundme me funded successfully");
        console.log("fundme balance:", address(fundMe).balance);

        // Verify funding worked as expected
        assertEq(fundMe.getFunder(0), address(fundFundMe));
        uint256 priorBalance = address(fundMe).balance;

        // make it CI-aware
        if (isCI) {
            // Double-check we're still the owner before withdraw
            assertEq(fundMe.getOwner(), address(this));
            fundMe.withdraw();
        } else {
            WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
            withdrawFundMe.withdrawFundMe(address(fundMe));
        }

        // Sanity check that we had funds to withdraw
        assertEq(address(fundMe).balance, 0);
        // Verify withdraw succeeded
        assertGt(priorBalance, 0);
    }
}
