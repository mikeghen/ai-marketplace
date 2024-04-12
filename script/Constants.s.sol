// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Constants {
    // broadcast/AIMarketplace/run-latest.json
    address constant TELLOR_PLAYGROUND = 0x5FbDB2315678afecb367f032d93F642f64180aa3;
    address constant MOCK_AUTOPAY = 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512;
    address constant AI_MARKETPLACE = 0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0;

    string systemPrompt = "You're a developer";
    string userPrompt = "What is Tellor";
    string model = "gpt-3";
    uint8 temperature = 10;
    uint256 payment = 1 ether;
}