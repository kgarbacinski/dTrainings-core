// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import {ITrainingsManager} from "./ITrainingsManager.sol";

contract TrainingsManager is ITrainingsManager {
    event TrainingCreated(bytes32 name, address creator);

    function addTraining(TrainingInfo calldata trainingInfo) override external {
        address creator = msg.sender;

        trainings[creator].push(trainingInfo);

        emit TrainingCreated(trainingInfo.name, msg.sender);
    }
}
