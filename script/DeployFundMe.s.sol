//SPDX-License-Identifier :MIT

pragma solidity ^0.8.24;

import {Script, console} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script {
    function run() external returns (FundMe) {
        HelperConfig helperConfig = new HelperConfig();

        address activeNetwork = helperConfig.activeNetworkConfig();
        // Logs
        console.log("PriceFeed address:", activeNetwork);
        console.log("Current chain ID:", block.chainid);

        vm.startBroadcast();
        FundMe fundMe = new FundMe(activeNetwork);
        vm.stopBroadcast();

        return fundMe;
    }
}
