// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "lib/forge-std/src/Test.sol";
import {TrainingsManagerProxy} from "src/proxies/TrainingsManagerProxy.sol";

contract DeployTrainingsManagerProxy is Test {
    /**
     * @dev The contract inherits from Test, which makes the testing and logging easier.
     */

    function deploy() public {
        vm.startBroadcast();
        ManagerProxy trainingsManagerProxy = new TrainingsManagerProxy();
        vm.stopBroadcast();
    }
}
