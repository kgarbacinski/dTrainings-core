// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import {ITrainingsManager} from "../../src/trainings/logic/ITrainingsManager.sol";
import {TrainingsManager} from "../../src/trainings/logic/TrainingsManager.sol";
import "forge-std/Test.sol";

contract DeployTrainingsManager is Test {
    function deploy() public {
        vm.startBroadcast();
        ITrainingsManager trainingsManager = new TrainingsManager();
        vm.stopBroadcast();
    }
}
