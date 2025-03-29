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

        trainings[creator].push(trainingInfo);

        emit TrainingCreated(trainingInfo.name, msg.sender);
    }

    function getTrainings(
        address creator
    ) external view override returns (TrainingInfo[] memory) {
        return trainings[creator];
    }

    function deleteTraining(bytes32 name) external override {
        address creator = msg.sender;

        for (uint256 i = 0; i < trainings[creator].length; i++) {
            if (trainings[creator][i].name == name) {
                delete trainings[creator][i];

                emit TrainingDeleted(name, msg.sender);

                break;
            }
        }
    }
}
