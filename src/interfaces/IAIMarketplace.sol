pragma solidity ^0.8.0;

interface IAIMarketplace {
    function submitRequest(
        string memory systemPrompt,
        string memory userPrompt,
        string memory model,
        uint8 temperature,
        uint256 paymentTrb
    ) external;
    function getQueryResult(uint256 requestId) external view returns (string memory);
}
