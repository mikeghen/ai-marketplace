// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";

import "../src/AIMarketplace.sol";
import "../src/interfaces/IAIMarketplace.sol";
import "../src/interfaces/ITellorPlayground.sol";
import "../src/mocks/MockAutopay.sol";
import "./Constants.s.sol";
import "usingtellor/TellorPlayground.sol";

contract SubmitValue is Script, Constants {

    function setUp() public {}

    function run() public { 
        uint256 requesterPrivateKey = vm.envUint("REQUESTER_PRIVATE_KEY");

        // Assume deployed TellorPlayground, MockAutopay, and AIMarketplace contracts
        IAIMarketplace aiMarketplace = IAIMarketplace(AI_MARKETPLACE);
        console.log("aiMarketplace", address(aiMarketplace));

        ITellorPlayground tellorPlayground = ITellorPlayground(TELLOR_PLAYGROUND);
        console.log("tellorPlayground", address(tellorPlayground));

        // Requester submits a request to the AIMarketplace
        vm.startBroadcast(requesterPrivateKey);



        bytes32 queryId = aiMarketplace.queryId(
            systemPrompt,
            userPrompt,
            model,
            temperature
        );

        bytes memory queryData = aiMarketplace.queryData(
            systemPrompt,
            userPrompt,
            model,
            temperature
        );

        bytes memory value = "The AI Marketplace typically refers to an online platform where developers and organizations can find, buy, sell, or exchange various AI-related products, services, models, datasets, and tools. It's essentially a marketplace dedicated to AI technologies, where users can discover solutions to their AI-related needs. These marketplaces can host a variety of offerings, including pre-trained machine learning models, APIs for integrating AI functionalities into applications, datasets for training AI algorithms, tools for model development and deployment, and consulting services related to AI implementation and optimization. AI marketplaces can be operated by independent companies, AI platform providers, cloud service providers, or online communities, and they serve as hubs for the AI ecosystem, fostering collaboration, innovation, and accessibility in the field of artificial intelligence.";

        tellorPlayground.submitValue(queryId, value, 0, queryData);
        
        vm.stopBroadcast();
    }
}
