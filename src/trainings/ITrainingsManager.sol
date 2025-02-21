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

    /// @dev Get all trainings created by a specific creator.
    /// @dev The getter for the whole array isn't generated automatically by Solidity, so we need to implement it manually.
    function getTrainings(
        address creator
    ) external view virtual returns (TrainingInfo[] calldata);
}
