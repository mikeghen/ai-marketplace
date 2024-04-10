// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";

import "../src/AIMarketplace.sol";
import "../src/mocks/MockAutopay.sol";
import "usingtellor/TellorPlayground.sol";

contract CounterScript is Script {
    function setUp() public {}

    function run() public { 
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployerAddress = address(uint160(uint256(keccak256(abi.encodePacked(deployerPrivateKey)))));
        vm.startBroadcast(deployerPrivateKey);

        // Deploy TellorPlayground
        TellorPlayground tellorPlayground = new TellorPlayground();

        MockAutopay autopay = new MockAutopay();

        // Deploy AIMarketplace
        AIMarketplace aiMarketplace = new AIMarketplace(
            payable(address(tellorPlayground)),
            address(autopay),
            address(tellorPlayground)
        );

        // 1000 TRB for the delpoyer
        tellorPlayground.faucet(deployerAddress);
        vm.stopBroadcast();
    }
}
