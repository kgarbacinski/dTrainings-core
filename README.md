# Deploy

```
source .env
forge script scripts/prod/01_DeployTrainingsManager.sol --rpc-url $RPC_URL --private-key $PRIVATE_KEY --etherscan-api-key $ETHERSCAN_API_KEY --broadcast --verify
```

# Formatting

```
npx prettier --write --plugin=prettier-plugin-solidity '<dir>/*.sol'
```

# Compiling
```
forge build
```