// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";

import "../src/AIMarketplace.sol";
import "../src/interfaces/IAIMarketplace.sol";
import "../src/interfaces/ITellorPlayground.sol";
import "../src/mocks/MockAutopay.sol";
import "./Constants.s.sol";
import "usingtellor/TellorPlayground.sol";

contract SubmitRequest is Script, Constants {

    function setUp() public {}

    function run() public { 
        uint256 requesterPrivateKey = vm.envUint("REQUESTER_PRIVATE_KEY");

        // Assume deployed TellorPlayground, MockAutopay, and AIMarketplace contracts
        IAIMarketplace aiMarketplace = IAIMarketplace(AI_MARKETPLACE);
        console.log("aiMarketplace", address(aiMarketplace));

        ITellorPlayground tellorPlayground = ITellorPlayground(TELLOR_PLAYGROUND);
        console.log("tellorPlayground", address(tellorPlayground));

        // 1000 TRB for the requester
        tellorPlayground.faucet(0x70997970C51812dc3A010C7d01b50e0d17dc79C8);
        console.log("faucet for requester: ", tellorPlayground.balanceOf(0x70997970C51812dc3A010C7d01b50e0d17dc79C8));


        // Requester submits a request to the AIMarketplace
        vm.startBroadcast(requesterPrivateKey);
        string memory systemPrompt = "You're a developer";
        string memory userPrompt = "What is Tellor";
        string memory model = "gpt-3.5";
        uint8 temperature = 10;
        uint256 payment = 1 ether;

        tellorPlayground.approve(address(aiMarketplace), payment);
        aiMarketplace.submitRequest(systemPrompt, userPrompt, model, temperature, payment);
        
        vm.stopBroadcast();
    }
}
