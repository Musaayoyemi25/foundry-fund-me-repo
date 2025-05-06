// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol"; //case sensitive
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is
    Script //script is case sensitive
{
    function run() external returns (FundMe) {
        // Before startBroadcast => Not a real tx
        HelperConfig helperConfig = new HelperConfig();
        address ethUsdPriceFeed = helperConfig.activeNetworkConfig(); //0x694AA1769357215DE4FAC081bf1f309aDC325306

        //to run a script
        //After startBroadcast => Real tx!
        vm.startBroadcast();
        //Mock
        FundMe fundMe = new FundMe(ethUsdPriceFeed);
        vm.stopBroadcast();
        return fundMe;
    }
}
