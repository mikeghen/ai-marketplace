pragma solidity ^0.8.0;

interface IAIMarketplace {

    function queryId(
        string memory systemPrompt,
        string memory userPrompt,
        string memory model,
        uint8 temperature
    ) external view returns (bytes32);

    function queryData(
        string memory systemPrompt,
        string memory userPrompt,
        string memory model,
        uint8 temperature
    ) external view returns (bytes memory);

    function submitRequest(
        string memory systemPrompt,
        string memory userPrompt,
        string memory model,
        uint8 temperature,
        uint256 paymentTrb
    ) external;
    
    function getQueryResult(bytes32 queryId) external view returns (string memory);
}
