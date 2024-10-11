// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import { WeirollWallet } from "lib/royco/src/WeirollWallet.sol";

/// @title WeirollWalletHelper
/// @notice A helper contract to enable calling view functions of WeirollWallet via DELEGATECALL.
/// @dev This contract contains view functions that can be called via DELEGATECALL to access the state of a WeirollWallet contract.
contract WeirollWalletHelper {
    /// @notice Gets the owner of the WeirollWallet.
    /// @dev Calls the `owner()` function of the WeirollWallet contract using `address(this)`.
    /// @return The address of the owner.
    function owner() external view returns (address) {
        return WeirollWallet(payable(address(this))).owner();
    }

    /// @notice Gets the address of the RecipeKernel contract associated with the WeirollWallet.
    /// @dev Calls the `recipeKernel()` function of the WeirollWallet contract using `address(this)`.
    /// @return The address of the RecipeKernel contract.
    function recipeKernel() external view returns (address) {
        return WeirollWallet(payable(address(this))).recipeKernel();
    }

    /// @notice Gets the amount of tokens deposited into the WeirollWallet.
    /// @dev Calls the `amount()` function of the WeirollWallet contract using `address(this)`.
    /// @return The amount of tokens deposited.
    function amount() external view returns (uint256) {
        return WeirollWallet(payable(address(this))).amount();
    }

    /// @notice Gets the timestamp until which the WeirollWallet is locked.
    /// @dev Calls the `lockedUntil()` function of the WeirollWallet contract using `address(this)`.
    /// @return The timestamp (in seconds since epoch) after which the wallet may be interacted with.
    function lockedUntil() external view returns (uint256) {
        return WeirollWallet(payable(address(this))).lockedUntil();
    }

    /// @notice Determines if the WeirollWallet is forfeitable.
    /// @dev Calls the `isForfeitable()` function of the WeirollWallet contract using `address(this)`.
    /// @return A boolean indicating if the wallet is forfeitable.
    function isForfeitable() external view returns (bool) {
        return WeirollWallet(payable(address(this))).isForfeitable();
    }

    /// @notice Gets the market ID associated with the WeirollWallet.
    /// @dev Calls the `marketId()` function of the WeirollWallet contract using `address(this)`.
    /// @return The market ID as a uint256.
    function marketId() external view returns (uint256) {
        return WeirollWallet(payable(address(this))).marketId();
    }

    /// @notice Checks if the order associated with the WeirollWallet has been executed.
    /// @dev Calls the `executed()` function of the WeirollWallet contract using `address(this)`.
    /// @return A boolean indicating if the order has been executed.
    function executed() external view returns (bool) {
        return WeirollWallet(payable(address(this))).executed();
    }

    /// @notice Checks if the WeirollWallet has been forfeited.
    /// @dev Calls the `forfeited()` function of the WeirollWallet contract using `address(this)`.
    /// @return A boolean indicating if the wallet has been forfeited.
    function forfeited() external view returns (bool) {
        return WeirollWallet(payable(address(this))).forfeited();
    }
}
