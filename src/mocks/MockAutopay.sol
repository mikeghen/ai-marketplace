pragma solidity ^0.8.0;

contract MockAutopay {

    mapping(bytes32 => uint256) public queryAmounts;

    /**
     * @dev Function to run a single tip
     * @param _queryId id of tipped data
     * @param _amount amount to tip
    */
    function tip(
        bytes32 _queryId,
        uint256 _amount,
        bytes calldata 
    ) external {
        queryAmounts[_queryId] = _amount;
    }

    function getCurrentTip(bytes32 _queryId)
        external
        view
        returns (uint256)
    {
        return queryAmounts[_queryId];
    }
}
