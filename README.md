# WeirollWalletHelper [![Tests](https://github.com/roycoprotocol/weiroll-wallet-helper/actions/workflows/test.yml/badge.svg)](https://github.com/roycoprotocol/weiroll-wallet-helper/actions/workflows/test.yml)

## Overview

This repository contains the implementation of a `WeirollWalletHelper` smart contract. The `WeirollWallet` is a smart contract wallet that can statefully execute commands using the Weiroll VM through recipes. The `WeirollWalletHelper` is a utility contract that provides view functions to access the state of a `WeirollWallet` via STATICCALL within Weiroll recipes.

## Contracts

### WeirollWalletHelper

The `WeirollWalletHelper` contract provides a set of view functions to access the state of a `WeirollWallet` contract. These functions can be called via STATICCALL to retrieve the following information:

- Wallet address - The address of the wallet.
- Native balance - The native asset balance of the wallet.
- Owner address - The address of the AP that filled an offer or got their offer filled in the Royco market.
- RecipeMarketHub address - The address of the RecipeMarketHub which created the wallet upon offer fulfillment.
- Token amount - Amount of the market's input token that was deposited into this wallet when the wallet was created (on offer fill).
- Unlock timestamp - The absolute timestamp that the Weiroll Wallet will be unlocked for the owner to withdraw their funds.
- Forfeitability - A boolean indicating whether or not this wallet is forfeitable (created for a forfeitable Royco market).
- Market hash - The unique identifier of the Royco Market associated with this wallet.
- Execution and forfeiture status - Booleans indicating whether or not the wallet's deposit recipe was executed and the wallet was forfeited respectively.

## License

This project is licensed under the MIT License.
