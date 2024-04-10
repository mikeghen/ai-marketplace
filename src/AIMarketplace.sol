// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "usingtellor/UsingTellor.sol";

contract AIMarketplace is UsingTellor {
    struct Request {
        string systemPrompt;
        string userPrompt;
        string model;
        uint8 temperature; // Scaled as 0 to 100, representing 0 to 1
        address requester;
        uint256 payment;
        bool executed;
        uint256 timestamp; // Timestamp of the Tellor query submission
    }

    uint256 public nextRequestId = 0;
    mapping(uint256 => Request) public requests;
    address public owner;
    mapping(bytes32 => uint256) public queryIdToRequestId;

    event RequestSubmitted(uint256 requestId, bytes32 queryId, uint256 payment);
    event QueryResultRetrieved(uint256 requestId, string result);

    constructor(address payable tellorAddress) UsingTellor(tellorAddress) {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can call this function");
        _;
    }

    function submitRequest(
        string memory systemPrompt,
        string memory userPrompt,
        string memory model,
        uint8 temperature,
        uint256 payment
    ) external payable {
        require(msg.value == payment, "Payment must match the transaction value");

        uint256 requestId = nextRequestId++;
        requests[requestId] = Request({
            systemPrompt: systemPrompt,
            userPrompt: userPrompt,
            model: model,
            temperature: temperature,
            requester: msg.sender,
            payment: payment,
            executed: false,
            timestamp: block.timestamp // Store submission timestamp
        });

        queryIdToRequestId[_queryId()] = requestId;

        emit RequestSubmitted(requestId, _queryId(), payment);
    }

    function getQueryResult(uint256 requestId) public view returns (string memory responseString) {
        Request storage request = requests[requestId];
        require(request.timestamp != 0, "Request does not exist");
        require(!request.executed, "Query already executed");
        // Assuming getDataBefore function can be used here based on TellorPlayground's functionality
        (bytes memory response,) = getDataBefore(_queryId(), block.timestamp);
        responseString = string(response);
    }

    function _queryData() internal pure returns (bytes memory) {
        return abi.encode(
            "ChatOpenAI",
            abi.encode(
                "You're a developer", 
                "What is Tellor?", 
                "gpt-3", 
                10
            )
        );
    }

    function _queryId() internal pure returns (bytes32) {
        return keccak256(_queryData());
    }
}
