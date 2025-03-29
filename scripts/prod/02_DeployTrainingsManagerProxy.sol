// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import {ManagerProxy} from "src/proxies/TrainingsManagerProxy.sol";
import {TrainingsManagerProxy} from "src/proxies/TrainingsManagerProxy.sol";
import {Script} from "forge-std/Script.sol";
import {ITrainingsManager} from "src/trainings/ITrainingsManager.sol";
import {TrainingsManager} from "src/trainings/TrainingsManager.sol";
import {console} from "forge-std/console.sol";

contract DeployTrainingsManagerProxy is Script {
    address private constant OWNER = address(0x1);

    function run() public {
        vm.startBroadcast();
        deployTrainingsManagerProxy();
        vm.stopBroadcast();
    }

    function deployTrainingsManagerProxy() internal {
        console.log("Deploying TrainingsManagerProxy...");

        ITrainingsManager trainingsManager = new TrainingsManager();
        console.log("TrainingsManager deployed at:", address(trainingsManager));

        bytes memory data = abi.encodeWithSignature("initialize()");
        TrainingsManagerProxy trainingsManagerProxy = new TrainingsManagerProxy(
            address(trainingsManager),
            OWNER,
            data
        );

        console.log(
            "TrainingsManagerProxy deployed at:",
            address(trainingsManagerProxy)
        );
    }
}
