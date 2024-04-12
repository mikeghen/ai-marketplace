// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";

import "../src/AIMarketplace.sol";
import "../src/interfaces/IAIMarketplace.sol";
import "../src/interfaces/ITellorPlayground.sol";
import "../src/mocks/MockAutopay.sol";
import "./Constants.s.sol";
import "usingtellor/TellorPlayground.sol";

contract ReadQueryData is Script, Constants {

    function setUp() public {}

    function run() public { 
        // Console log all of the AI Marketplaces Requests
        IAIMarketplace aiMarketplace = IAIMarketplace(AI_MARKETPLACE);
        console.log("aiMarketplace", address(aiMarketplace));
    
        bytes32 queryId = aiMarketplace.queryId(
            systemPrompt,
            userPrompt,
            model,
            temperature
        );
        
        string memory response = aiMarketplace.getQueryResult(queryId);
        console.log("response", response);
        
    }
}
