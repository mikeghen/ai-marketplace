// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/AIMarketplace.sol";
import "usingtellor/TellorPlayground.sol";

contract AIMarketplaceTest is Test {
    AIMarketplace public aiMarketplace;
    TellorPlayground public tellorPlayground;

    function setUp() public {
        // Deploy the TellorPlayground contract
        tellorPlayground = new TellorPlayground();
        
        // Deploy the AIMarketplace contract, passing the address of TellorPlayground
        aiMarketplace = new AIMarketplace(payable(address(tellorPlayground)));

        // Add some TRB tokens to the tester and the AI Marketplace for fees (if necessary)
        tellorPlayground.faucet(address(this));
        tellorPlayground.faucet(address(aiMarketplace));
    }

    function testSubmitAndRetrieveQuery() public {
        // Setup
        string memory systemPrompt = "Hello";
        string memory userPrompt = "Tellor";
        string memory model = "gpt-3.5";
        uint8 temperature = 10;
        uint256 payment = 1 ether;
        
        // Test submitting a request
        vm.deal(address(this), payment); // Provide this contract some ether for the transaction
        vm.startPrank(address(this));
        aiMarketplace.submitRequest{value: payment}(systemPrompt, userPrompt, model, temperature, payment);
        vm.stopPrank();

        uint256 requestId = 0; // Assuming this is the first and only request
        bytes32 queryId = keccak256(abi.encode(systemPrompt, userPrompt, model, temperature));
        bytes memory response = "Test Response";

        // Simulate the Tellor oracle providing a response
        tellorPlayground.submitValue(queryId, response, 0, "");

        // Retrieve the query result
        string memory result = aiMarketplace.getQueryResult(requestId);

        // Assertions
        assertEq(result, "Test Response", "The retrieved result does not match the expected response.");
    }

}
