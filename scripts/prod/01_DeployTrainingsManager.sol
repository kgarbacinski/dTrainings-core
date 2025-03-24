// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "forge-std/Script.sol";
import {ITrainingsManager} from "../../src/trainings/logic/ITrainingsManager.sol";
import {TrainingsManager} from "../../src/trainings/logic/TrainingsManager.sol";

contract DeployTrainingsManager is Script {
    function run() public {
        vm.startBroadcast();
        deployTrainingsManager();
        vm.stopBroadcast();
    }

    function deployTrainingsManager() internal {
        console.log("Deploying TrainingsManager...");

        ITrainingsManager trainingsManager = new TrainingsManager();

        console.log("TrainingsManager deployed at:", address(trainingsManager));
    }
}
