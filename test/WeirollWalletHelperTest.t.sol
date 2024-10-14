// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import { WeirollWalletHelper, WeirollWallet } from "src/WeirollWalletHelper.sol";
import { ClonesWithImmutableArgs } from "lib/royco/lib/clones-with-immutable-args/src/ClonesWithImmutableArgs.sol";
import "lib/forge-std/src/Test.sol";

contract WeirollWalletHelperTest is Test {
    using ClonesWithImmutableArgs for address;

    WeirollWallet public weirollWallet;
    WeirollWalletHelper public weirollWalletHelper;
    address public WEIROLL_WALLET_IMPLEMENTATION;

    function setUp() public {
        // Deploy the WeirollWallet implementation contract
        WEIROLL_WALLET_IMPLEMENTATION = address(new WeirollWallet());

        // Deploy the WeirollWalletHelper
        weirollWalletHelper = new WeirollWalletHelper();
    }

    function testFuzz_WeirollWalletHelper(
        address owner,
        address recipeMarketHub,
        uint256 amount,
        uint256 lockedUntil,
        bool forfeitable,
        bytes32 marketHash,
        uint256 timestamp,
        uint256 walletNativeBalance
    )
        public
    {
        // Clone the WeirollWallet with immutable args
        bytes memory data = abi.encodePacked(owner, recipeMarketHub, amount, lockedUntil, forfeitable, marketHash);

        address cloneAddress = WEIROLL_WALLET_IMPLEMENTATION.clone(data);
        weirollWallet = WeirollWallet(payable(cloneAddress));
        vm.deal(cloneAddress, walletNativeBalance);

        // Prepare the command to call owner()
        bytes32[] memory commands = new bytes32[](10);
        bytes[] memory state = new bytes[](10);

        commands[0] = buildDelegateCallCommand(bytes4(keccak256("thisWallet()")), 0);
        commands[1] = buildDelegateCallCommand(bytes4(keccak256("nativeBalance()")), 1);
        commands[2] = buildDelegateCallCommand(WeirollWallet.owner.selector, 2);
        commands[3] = buildDelegateCallCommand(WeirollWallet.recipeMarketHub.selector, 3);
        commands[4] = buildDelegateCallCommand(WeirollWallet.amount.selector, 4);
        commands[5] = buildDelegateCallCommand(WeirollWallet.lockedUntil.selector, 5);
        commands[6] = buildDelegateCallCommand(WeirollWallet.isForfeitable.selector, 6);
        commands[7] = buildDelegateCallCommand(WeirollWallet.marketHash.selector, 7);
        commands[8] = buildDelegateCallCommand(bytes4(keccak256("executed()")), 8);
        commands[9] = buildDelegateCallCommand(bytes4(keccak256("forfeited()")), 9);

        // Time travel to the fuzzed timestamp
        vm.warp(timestamp);

        // Simulate call from recipeMarketHub (if required by access control)
        vm.startPrank(recipeMarketHub);

        bool forfeited = false;

        // If forfeitable and locked, randomly choose to forfeit for later assertion
        if (forfeitable && timestamp < lockedUntil) {
            if (uint256(keccak256(abi.encode(owner, recipeMarketHub, amount, lockedUntil, forfeitable, marketHash))) % 2 == 1) {
                weirollWallet.forfeit();
                forfeited = true;
            }
        }

        // Execute the Weiroll script
        bytes[] memory outputs = weirollWallet.executeWeiroll(commands, state);

        // Decode and verify the output
        address returnedWalletAddress = abi.decode(outputs[0], (address));
        assertEq(returnedWalletAddress, cloneAddress);

        // Decode and verify the output
        uint256 returnedNativeBalance = abi.decode(outputs[1], (uint256));
        assertEq(returnedNativeBalance, walletNativeBalance);

        // Decode and verify the output
        address returnedOwner = abi.decode(outputs[2], (address));
        assertEq(returnedOwner, owner);

        // Decode and verify the output
        address returnedrecipeMarketHub = abi.decode(outputs[3], (address));
        assertEq(returnedrecipeMarketHub, recipeMarketHub);

        // Decode and verify the output
        uint256 returnedAmount = abi.decode(outputs[4], (uint256));
        assertEq(returnedAmount, amount);

        // Decode and verify the output
        uint256 returnedLockedUntil = abi.decode(outputs[5], (uint256));
        assertEq(returnedLockedUntil, lockedUntil);

        bool returnedForfeitable = abi.decode(outputs[6], (bool));
        assertEq(returnedForfeitable, forfeitable);

        bytes32 returnedMarketHash = abi.decode(outputs[7], (bytes32));
        assertEq(returnedMarketHash, marketHash);

        // Decode and verify the output
        bool returnedExecuted = abi.decode(outputs[8], (bool));
        assertEq(returnedExecuted, true);

        bool returnedForfeited = abi.decode(outputs[9], (bool));
        assertEq(returnedForfeited, forfeited);

        vm.stopPrank();
    }

    // Helper function to build a Weiroll command for DELEGATECALL
    function buildDelegateCallCommand(bytes4 selector, uint8 outputIndex) internal view returns (bytes32 command) {
        // Flags: DELEGATECALL (calltype = 0x00)
        uint8 f = 0x00;

        // Input list: No arguments (END_OF_ARGS = 0xff)
        bytes6 inputData = hex"ffffffffffff";

        // Output specifier (fixed length return value stored at index 0 of the output array)
        uint8 o = outputIndex;

        // Target address: Helper contract address
        address target = address(weirollWalletHelper);

        // Encode args
        command = bytes32(abi.encodePacked(selector, f, inputData, o, target));
    }
}
