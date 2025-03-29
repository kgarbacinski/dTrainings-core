// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

interface ITrainingsManager {
    enum TrainingState {
        Approved,
        Unapproved
    }

    struct TrainingInfo {
        bytes32 name; // unique name for the training of the owner
        bytes32 description;
        uint256 durationInMinutes;
    }

    event TrainingCreated(bytes32 name, address creator);
    event TrainingDeleted(bytes32 name, address creator);

    /// @notice Adds a new training for the calling user.
    /// @param trainingInfo The details of the training to be added.
    function addTraining(TrainingInfo calldata trainingInfo) external virtual;

    /// @notice Get all trainings created by a specific creator.
    /// @param creator The address of the training creator.
    /// @return An array of TrainingInfo structs created by the given address.
    function getTrainings(
        address creator
    ) external view virtual returns (TrainingInfo[] memory);

    /// @notice Deletes a training by name.
    /// @param name The unique name of the training to be deleted.
    function deleteTraining(bytes32 name) external virtual;
}
