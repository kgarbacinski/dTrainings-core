// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

abstract contract ITrainingsManager {
    enum TrainingState {
        Approved,
        Unapproved
    }

    struct TrainingInfo {
        bytes32 name;
        bytes32 description;
        uint256 durationInMinutes;
    }

    mapping(address => TrainingInfo[]) public trainings;

    function addTraining(TrainingInfo calldata trainingInfo) external virtual;
}
