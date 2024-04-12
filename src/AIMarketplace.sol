// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "usingtellor/UsingTellor.sol";
import "./interfaces/IAutopay.sol";

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

    IAutopay public autopay;
    IERC20 public trb;
    uint256 public nextRequestId = 0;
    mapping(uint256 => Request) public requests;
    mapping(bytes32 => uint256) public queryIdToRequestId;

    event RequestSubmitted(uint256 requestId, bytes32 queryId, uint256 payment);
    event QueryResultRetrieved(uint256 requestId, string result);

    constructor(
        address payable tellorAddress, 
        address autopayAddress,
        address trbAddress
    ) UsingTellor(tellorAddress) {
        autopay = IAutopay(autopayAddress);
        trb = IERC20(trbAddress);
    }

    function submitRequest(
        string memory systemPrompt,
        string memory userPrompt,
        string memory model,
        uint8 temperature,
        uint256 paymentTrb
    ) external {
        trb.transferFrom(msg.sender, address(this), paymentTrb);

        uint256 requestId = nextRequestId++;
        requests[requestId] = Request({
            systemPrompt: systemPrompt,
            userPrompt: userPrompt,
            model: model,
            temperature: temperature,
            requester: msg.sender,
            payment: paymentTrb,
            executed: false,
            timestamp: block.timestamp // Store submission timestamp
        });

        bytes32 _queryId = queryId(systemPrompt, userPrompt, model, temperature);

        queryIdToRequestId[_queryId] = requestId;

        // Tip Tellor for the query
        autopay.tip(_queryId, paymentTrb, queryData(
            systemPrompt,
            userPrompt,
            model,
            temperature
        ));

        emit RequestSubmitted(requestId, _queryId, paymentTrb);
    }

    function getQueryResult(bytes32 _queryId) public view returns (string memory responseString) {
        (bytes memory response,) = getDataBefore(_queryId, block.timestamp + 1);
        responseString = string(response);
    }

    function queryData(
        string memory systemPrompt,
        string memory userPrompt,
        string memory model,
        uint8 temperature
    ) public pure returns (bytes memory) {
        return abi.encode(
            "ChatOpenAI",
            abi.encode(
                systemPrompt,
                userPrompt,
                model,
                temperature
            )
        );
    }

    function queryId(
        string memory systemPrompt,
        string memory userPrompt,
        string memory model,
        uint8 temperature
    ) public pure returns (bytes32) {
        return keccak256(queryData(
            systemPrompt,
            userPrompt,
            model,
            temperature
        ));
    }
}
