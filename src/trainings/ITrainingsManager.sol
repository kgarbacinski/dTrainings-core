// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

abstract contract ITrainingsManager {
    enum TrainingState {
        Approved,
        Unapproved
    }

    struct TrainingInfo {
        bytes32 name; // unique name for the trainings of owner
        bytes32 description;
        uint256 durationInMinutes;
    }

    event TrainingCreated(bytes32 name, address creator);
    event TrainingDeleted(bytes32 name, address creator);

    mapping(address => TrainingInfo[]) public trainings;

    function addTraining(TrainingInfo calldata trainingInfo) external virtual;

    /// @dev Get all trainings created by a specific creator.
    /// @dev The getter for the whole array isn't generated automatically by Solidity, so we need to implement it manually.
    function getTrainings(
        address creator
    ) external view virtual returns (TrainingInfo[] calldata);

    function deleteTraining(bytes32 name) external virtual;
}
