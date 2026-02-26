// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import {ITrainingsManager} from "./ITrainingsManager.sol";

contract TrainingsManager is ITrainingsManager {
    mapping(address => TrainingInfo[]) private trainings;
    bool private initialized;

    event Initialized(address owner);

    /// @notice Initializes the contract (to be called via proxy)
    function initialize() external {
        require(!initialized, "Already initialized");
        initialized = true;
        emit Initialized(msg.sender);
    }

    function addTraining(TrainingInfo calldata trainingInfo) external override {
        address creator = msg.sender;

        for (uint256 i = 0; i < trainings[creator].length; i++) {
            require(
                trainings[creator][i].name != trainingInfo.name,
                "TrainingsManager: Training with the same name already exists"
            );
        }

        trainings[creator].push(TrainingInfo({
            name: trainingInfo.name,
            description: trainingInfo.description,
            durationInMinutes: trainingInfo.durationInMinutes,
            createdAt: block.timestamp
        }));

        emit TrainingCreated(trainingInfo.name, msg.sender);
    }

    function getTrainings(
        address creator
    ) external view override returns (TrainingInfo[] memory) {
        return trainings[creator];
    }

    function deleteTraining(bytes32 name) external override {
        address creator = msg.sender;
        uint256 len = trainings[creator].length;

        for (uint256 i = 0; i < len; i++) {
            if (trainings[creator][i].name == name) {
                trainings[creator][i] = trainings[creator][len - 1];
                trainings[creator].pop();

                emit TrainingDeleted(name, msg.sender);
                return;
            }
        }

        revert("TrainingsManager: Training not found");
    }

    function updateTraining(bytes32 name, bytes32 newDescription, uint256 newDurationInMinutes) external override {
        address creator = msg.sender;

        for (uint256 i = 0; i < trainings[creator].length; i++) {
            if (trainings[creator][i].name == name) {
                trainings[creator][i].description = newDescription;
                trainings[creator][i].durationInMinutes = newDurationInMinutes;

                emit TrainingUpdated(name, msg.sender);
                return;
            }
        }

        revert("TrainingsManager: Training not found");
    }

    function getTrainingCount(address creator) external view override returns (uint256) {
        return trainings[creator].length;
    }
}
