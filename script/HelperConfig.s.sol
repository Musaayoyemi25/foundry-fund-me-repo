// SPDX-License-Identifier: MIT

// 1. Deploy mocks when we are on a local anvil chain
// 2. Keep tracks of contract address across different chains
//Sepolia ETH/USD
// Mainnet ETH/USD

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    ////not initially script, but it needs to be
    //a script so we can acess the vm keyword
    // if we are on a local anvil chain, deploy mocks
    // otherwise, grab the existing address from the live network

    NetworkConfig public activeNetworkConfig;

    uint8 public constant DECIMALS = 8; // representing magic numbers
    int256 public constant INITIAL_PRICE = 2000 * 10 ** 8; //2000

    struct NetworkConfig {
        address priceFeed; //ETH/USD price feed address
    }

    constructor() {
        if (block.chainid == 11155111) {
            //Sepolia
            activeNetworkConfig = getSepoliaEthConfig();
        } else if (block.chainid == 1) {
            //Mainnet
            activeNetworkConfig = getMainnetEthConfig();
        } else {
            //Localhost or anvil
            activeNetworkConfig = getOrCreateAnvilEthConfig(); //mock address
        }
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        //returns a configuration
        //for everything we need on sepolia
        //1. Price feed address
        NetworkConfig memory sepoliaConfig = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306 //Sepolia ETH/USD address
        });
        return sepoliaConfig; //returns the configuration
    }

    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        //we need to create a contact address first
        if (activeNetworkConfig.priceFeed != address(0)) {
            //have we set this price feed as something before?
            // if yes, just go ahead and return and not run the brodcast
            return activeNetworkConfig;
        }
        //Price feed address

        // 1. Deploy the mocks
        // 2. Return the mock address

        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(DECIMALS, INITIAL_PRICE); //2000
        vm.stopBroadcast();

        NetworkConfig memory anvilConfig = NetworkConfig({
            priceFeed: address(mockPriceFeed) //Mock address
        });
        return anvilConfig; //returns the configuration
    }

    function getMainnetEthConfig() public pure returns (NetworkConfig memory) {
        //returns a configuration
        //Price feed address
        NetworkConfig memory mainnetConfig = NetworkConfig({
            priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419 //Mainnet ETH/USD address
        });
        return mainnetConfig; //returns the configuration
    }
}
