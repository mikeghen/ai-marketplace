// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ITellorPlayground {
    // Events
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event NewReport(bytes32 indexed _queryId, uint256 _time, bytes _value, uint256 _nonce, bytes _queryData, address _reporter);
    event NewStaker(address indexed _staker, uint256 _amount);
    event StakeWithdrawRequested(address indexed _staker, uint256 _amount);
    event StakeWithdrawn(address indexed _staker);
    event Transfer(address indexed from, address indexed to, uint256 value);

    // Function signatures
    function addStakingRewards(uint256 _amount) external;
    function approve(address _spender, uint256 _amount) external returns (bool);
    function beginDispute(bytes32 _queryId, uint256 _timestamp) external;
    function depositStake(uint256 _amount) external;
    function faucet(address _user) external;
    function requestStakingWithdraw(uint256 _amount) external;
    function submitValue(bytes32 _queryId, bytes calldata _value, uint256 _nonce, bytes memory _queryData) external;
    function transfer(address _recipient, uint256 _amount) external returns (bool);
    function transferFrom(address _sender, address _recipient, uint256 _amount) external returns (bool);
    function withdrawStake() external;
    
    // View / Pure functions
    function allowance(address _owner, address _spender) external view returns (uint256);
    function balanceOf(address _account) external view returns (uint256);
    function decimals() external view returns (uint8);
    function getDataBefore(bytes32 _queryId, uint256 _timestamp) external view returns (bool, bytes memory, uint256);
    function getReporterByTimestamp(bytes32 _queryId, uint256 _timestamp) external view returns (address);
    function getStakeAmount() external view returns (uint256);
    function getStakerInfo(address _stakerAddress) external view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, bool);
    function governance() external view returns (address);
    function name() external view returns (string memory);
    function retrieveData(bytes32 _queryId, uint256 _timestamp) external view returns (bytes memory);
    function symbol() external view returns (string memory);
    function totalSupply() external view returns (uint256);
}
