// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Script.sol";

// Import the PredepositExecutor contract and its dependencies
import "src/WeirollWalletHelper.sol";

// Deployment commands:
// 1. forge flatten --output src/WeirollWalletHelper.flattened.sol src/WeirollWalletHelper.sol
// 2. source .env
// 3. forge script script/Deploy.s.sol --rpc-url {RPC_URL} --broadcast --verify -vvvv --etherscan-api-key=${API_KEY} --verifier-url {URL}

contract WeirollWalletHelper_DeployScript is Script {
    function setUp() public { }

    function run() public {
        // Fetch the deployer's private key from environment variables
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);

        // Start broadcasting transactions
        vm.startBroadcast(deployerPrivateKey);

        // Deploy the WeirollWalletHelper contract
        WeirollWalletHelper helper = new WeirollWalletHelper();

        // Output the address of the deployed WeirollWalletHelper contract
        console.log("WeirollWalletHelper deployed at:", address(helper));

        // Stop broadcasting transactions
        vm.stopBroadcast();
    }
}
