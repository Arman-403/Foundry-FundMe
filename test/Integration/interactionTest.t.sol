//SPDX-License-Identifier :MIT

pragma solidity ^0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundMe} from "../../src/FundMe.sol";
import {MockV3Aggregator} from "../../test/mocks/MockV3Aggregator.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interaction.s.sol";
import {CodeConstants} from "../../script/HelperConfig.s.sol";

contract interactionTest is Test, CodeConstants {
    FundMe public fundMe;

    function setUp() public {
        bool isCI = vm.envOr("CI", false);

        if (isCI) {
            // Deploy mock setup for CI
            MockV3Aggregator mockV3Aggregator = new MockV3Aggregator(DECIMALS, INITIAL_PRICE);
            fundMe = new FundMe(address(mockV3Aggregator));
            console.log("Recent Mock Price Feed address for CI", address(mockV3Aggregator));
            console.log("Running on CI : Deployed FundMe with mock ");
        } else {
            // normal deployer for local development
            DeployFundMe deployer = new DeployFundMe();
            fundMe = deployer.run();
            console.log("Running Locally: using DeployFundMe script");
        }
    }

    //chore: add hybrid CI-aware test setup with mock deployment support

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
