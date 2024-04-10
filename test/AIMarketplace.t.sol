// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/AIMarketplace.sol";
import "../src/mocks/MockAutopay.sol";
import "usingtellor/TellorPlayground.sol";

contract AIMarketplaceTest is Test {
    AIMarketplace public aiMarketplace;
    MockAutopay public autopay;
    TellorPlayground public tellorPlayground;

    function setUp() public {

        tellorPlayground = new TellorPlayground();
        autopay = new MockAutopay();
        aiMarketplace = new AIMarketplace(
            payable(address(tellorPlayground)),
            address(autopay),
            address(tellorPlayground)
        );

        // 1000 TRB for this test
        tellorPlayground.faucet(address(this));
    }

    function testSubmitAndRetrieveQuery() public {
        string memory systemPrompt = "Hello";
        string memory userPrompt = "Tellor";
        string memory model = "gpt-3.5";
        uint8 temperature = 10;
        uint256 paymentTrb = 1 ether;
        
        // Test submitting a request
        vm.deal(address(this), paymentTrb); // Provide this contract some ether for the transaction
        vm.startPrank(address(this));
        tellorPlayground.approve(address(aiMarketplace), paymentTrb);
        aiMarketplace.submitRequest(systemPrompt, userPrompt, model, temperature, paymentTrb);
        vm.stopPrank();

        uint256 requestId = 0; // Assuming this is the first and only request
        bytes memory queryData = abi.encode(
            "ChatOpenAI",
            abi.encode(
                "You're a developer", 
                "What is Tellor?", 
                "gpt-3", 
                10
            )
        );
        bytes32 queryId = keccak256(queryData);

        // Check the tip was received
        assertEq(autopay.getCurrentTip(queryId), paymentTrb, "The tip amount does not match the expected value.");

        bytes memory response = "Test Response";

        // Simulate the Tellor oracle providing a response
        tellorPlayground.submitValue(queryId, response, 0, queryData);

        vm.warp(block.timestamp + 1); // Advance the block timestamp by 1 second

        // Retrieve the query result
        string memory result = aiMarketplace.getQueryResult(requestId);

        // Assertions
        assertEq(result, "Test Response", "The retrieved result does not match the expected response.");
    }

}
