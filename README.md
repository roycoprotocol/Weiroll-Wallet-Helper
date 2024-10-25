# WeirollWalletHelper

## Overview

This repository contains the implementation of a `WeirollWalletHelper` smart contract. The `WeirollWallet` is a smart contract wallet that can execute commands using the Weiroll VM. The `WeirollWalletHelper` is a utility contract that provides view functions to access the state of a `WeirollWallet` via STATICCALL in Weiroll scripts.

## Contracts

### WeirollWalletHelper

The `WeirollWalletHelper` contract provides a set of view functions to access the state of a `WeirollWallet` contract. These functions can be called via STATICCALL to retrieve the following information:

- Wallet address
- Native balance
- Owner address
- RecipeMarketHub address
- Token amount
- Lock timestamp
- Forfeitability
- Market hash
- Execution and forfeiture status

## License

This project is licensed under the MIT License.

## Disclaimer

This software is provided "as is", without warranty of any kind. Use at your own risk.