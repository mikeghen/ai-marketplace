// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";

import "../src/AIMarketplace.sol";
import "../src/interfaces/IAIMarketplace.sol";
import "../src/interfaces/ITellorPlayground.sol";
import "../src/mocks/MockAutopay.sol";
import "./Constants.s.sol";
import "usingtellor/TellorPlayground.sol";

contract VerifyDeploy is Script, Constants {

    function setUp() public {}

    function run() public { 
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        uint256 requesterPrivateKey = vm.envUint("REQUESTER_PRIVATE_KEY");
        uint256 reporterPrivateKey = vm.envUint("REPORTER_PRIVATE_KEY");
        address requesterAddress = address(uint160(uint256(keccak256(abi.encodePacked(requesterPrivateKey)))));

        vm.startBroadcast(deployerPrivateKey);
        // Assume deployed TellorPlayground, MockAutopay, and AIMarketplace contracts
        IAIMarketplace aiMarketplace = IAIMarketplace(AI_MARKETPLACE);
        console.log("aiMarketplace", address(aiMarketplace));

        ITellorPlayground tellorPlayground = ITellorPlayground(TELLOR_PLAYGROUND);
        console.log("tellorPlayground", address(tellorPlayground));

        // 1000 TRB for the requester
        tellorPlayground.faucet(0x70997970C51812dc3A010C7d01b50e0d17dc79C8);
        console.log("faucet for requester: ", tellorPlayground.balanceOf(0x70997970C51812dc3A010C7d01b50e0d17dc79C8));

        vm.stopBroadcast();

        // Requester submits a request to the AIMarketplace
        vm.startBroadcast(requesterPrivateKey);

        tellorPlayground.approve(address(aiMarketplace), payment);
        aiMarketplace.submitRequest(systemPrompt, userPrompt, model, temperature, payment);
        
        uint256 requestId = 0; // Assuming this is the first and only request
        bytes memory queryData = abi.encode(
            "ChatOpenAI",
            abi.encode(
                systemPrompt,
                userPrompt,
                model,
                temperature
            )
        );
        bytes32 queryId = keccak256(queryData);

        vm.stopBroadcast();

        // Reporter responses to the submission
        vm.startBroadcast(reporterPrivateKey);
        bytes memory response = "Test Response";
        tellorPlayground.submitValue(queryId, response, 0, queryData);

        vm.stopBroadcast();

        // FIX: Submitted value `response` not recovered in getQueryResult
        string memory result = aiMarketplace.getQueryResult(queryId);
        console.log("Result: ", result);
    }
}
