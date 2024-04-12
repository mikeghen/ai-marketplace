# Scripting

## Deployment
```
forge script script/AIMarketplace.s.sol:AIMarketplaceScript --rpc-url http://127.0.0.1:8545
```
Add `--broadcast` to execute the deployment on the network.

## Verify Deployment
```
forge script script/VerifyDeploy.s.sol:VerifyDeploy --rpc-url http://127.0.0.1:8545
```
Add `--broadcast` to execute the deployment on the network.

## Read Query Data
```
forge script script/ReadQueryData.s.sol:ReadQueryData --rpc-url http://127.0.0.1:8545
```