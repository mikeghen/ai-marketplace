// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";

import "../src/AIMarketplace.sol";
import "../src/interfaces/IAIMarketplace.sol";
import "../src/interfaces/ITellorPlayground.sol";
import "../src/mocks/MockAutopay.sol";
import "usingtellor/TellorPlayground.sol";

contract VerifyDeploy is Script {

    // broadcast/AIMarketplace/run-latest.json
    address constant TELLOR_PLAYGROUND = 0x5FbDB2315678afecb367f032d93F642f64180aa3;
    address constant MOCK_AUTOPAY = 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512;
    address constant AI_MARKETPLACE = 0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0;

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
        string memory systemPrompt = "Hello";
        string memory userPrompt = "Tellor";
        string memory model = "gpt-3.5";
        uint8 temperature = 10;
        uint256 paymentTrb = 1 ether;

        tellorPlayground.approve(address(aiMarketplace), paymentTrb);
        aiMarketplace.submitRequest(systemPrompt, userPrompt, model, temperature, paymentTrb);
        
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
        string memory result = aiMarketplace.getQueryResult(requestId);
        console.log("Result: ", result);
    }
}
