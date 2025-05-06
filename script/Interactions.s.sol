//Fund
//Withdraw

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";

//Our Script for funding FundMe contract
contract FundFundMe is Script {
    uint256 constant SEND_VALUE = 0.01 ether;
    // Make the function payable
    function fundFundMe(address mostRecentlyDeployed) public payable {
        FundMe(payable(mostRecentlyDeployed)).fund{value: msg.value}();
        console.log("Funded FundMe with %s", msg.value);
    }

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        ); //looks into the folder and finds the run-latest.json file
        vm.startBroadcast();
        fundFundMe(mostRecentlyDeployed);
        vm.stopBroadcast();
    }
}

// Our Script for withdrawing from FundMe contract
contract WithdrawFundMe is Script {
    function withdrawFundMe(address mostRecentlyDeployed) public {
        FundMe(payable(mostRecentlyDeployed)).withdraw();
    }

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        ); //looks into the folder and finds the run-latest.json file
        vm.startBroadcast();
        withdrawFundMe(mostRecentlyDeployed);
        vm.stopBroadcast();
    }
}
