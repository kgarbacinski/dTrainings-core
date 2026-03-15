pragma solidity ^0.8.10;

import "src/trainings/TrainingsManager.sol";
import "lib/forge-std/src/Test.sol";
import "src/trainings/ITrainingsManager.sol";

contract TrainingsManagerTest is Test {
    ITrainingsManager public trainingsManager;

    address public trainingsCreator1 = makeAddr("creator1");
    address public trainingsCreator2 = makeAddr("creator2");

    function setUp() public {
        trainingsManager = new TrainingsManager();
    }

    function test_AddAndGetTrainings() public {
        ITrainingsManager.TrainingInfo memory trainingInfo1 = ITrainingsManager
            .TrainingInfo({
                name: "Training 1",
                description: "Description 1",
                durationInMinutes: 60,
                createdAt: 0
            });
        ITrainingsManager.TrainingInfo memory trainingInfo2 = ITrainingsManager
            .TrainingInfo({
                name: "Training 2",
                description: "Description 2",
                durationInMinutes: 120,
                createdAt: 0
            });

        vm.prank(trainingsCreator1);
        vm.expectEmit(true, true, false, true);
        emit ITrainingsManager.TrainingCreated(
            trainingInfo1.name,
            trainingsCreator1
        );

        trainingsManager.addTraining(trainingInfo1);

        vm.prank(trainingsCreator2);

        vm.expectEmit(true, true, false, true);
        emit ITrainingsManager.TrainingCreated(
            trainingInfo2.name,
            trainingsCreator2
        );

        trainingsManager.addTraining(trainingInfo2);

        ITrainingsManager.TrainingInfo[] memory trainings1 = trainingsManager
            .getTrainings(trainingsCreator1);
        assertEq(trainings1.length, 1);
        assertEq(trainings1[0].name, trainingInfo1.name);
        assertEq(trainings1[0].description, trainingInfo1.description);
        assertEq(
            trainings1[0].durationInMinutes,
            trainingInfo1.durationInMinutes
        );
        assertGt(trainings1[0].createdAt, 0);

        ITrainingsManager.TrainingInfo[] memory trainings2 = trainingsManager
            .getTrainings(trainingsCreator2);
        assertEq(trainings2.length, 1);
        assertEq(trainings2[0].name, trainingInfo2.name);
        assertEq(trainings2[0].description, trainingInfo2.description);
        assertEq(
            trainings2[0].durationInMinutes,
            trainingInfo2.durationInMinutes
        );
        assertGt(trainings2[0].createdAt, 0);
    }

    function test_AddTrainingReverts() public {
        ITrainingsManager.TrainingInfo memory trainingInfo1 = ITrainingsManager
            .TrainingInfo({
                name: "Training 1",
                description: "Description 1",
                durationInMinutes: 60,
                createdAt: 0
            });
        ITrainingsManager.TrainingInfo memory trainingInfo2 = ITrainingsManager
            .TrainingInfo({
                name: "Training 1", // A user wants to create a training with already existing name
                description: "Description 2",
                durationInMinutes: 120,
                createdAt: 0
            });

        vm.startPrank(trainingsCreator1);
        trainingsManager.addTraining(trainingInfo1);

        vm.expectRevert(
            "TrainingsManager: Training with the same name already exists"
        );
        trainingsManager.addTraining(trainingInfo2); // should revert
        vm.stopPrank();
    }

    function test_DeleteTraining() public {
        ITrainingsManager.TrainingInfo memory t1 = ITrainingsManager
            .TrainingInfo({
                name: "Training 1",
                description: "Description 1",
                durationInMinutes: 60,
                createdAt: 0
            });
        ITrainingsManager.TrainingInfo memory t2 = ITrainingsManager
            .TrainingInfo({
                name: "Training 2",
                description: "Description 2",
                durationInMinutes: 90,
                createdAt: 0
            });
        ITrainingsManager.TrainingInfo memory t3 = ITrainingsManager
            .TrainingInfo({
                name: "Training 3",
                description: "Description 3",
                durationInMinutes: 120,
                createdAt: 0
            });

        vm.startPrank(trainingsCreator1);
        trainingsManager.addTraining(t1);
        trainingsManager.addTraining(t2);
        trainingsManager.addTraining(t3);

        ITrainingsManager.TrainingInfo[] memory before = trainingsManager
            .getTrainings(trainingsCreator1);
        assertEq(before.length, 3);

        // Delete the middle one (Training 2)
        vm.expectEmit(true, true, false, true);
        emit ITrainingsManager.TrainingDeleted(t2.name, trainingsCreator1);
        trainingsManager.deleteTraining(t2.name);

        ITrainingsManager.TrainingInfo[] memory after_ = trainingsManager
            .getTrainings(trainingsCreator1);
        assertEq(after_.length, 2);

        // After swap-and-pop: Training 1 at [0], Training 3 moved to [1] (was swapped from last)
        assertEq(after_[0].name, t1.name);
        assertEq(after_[1].name, t3.name);

        // Verify no zeroed-out slots
        assertGt(after_[0].durationInMinutes, 0);
        assertGt(after_[1].durationInMinutes, 0);

        vm.stopPrank();
    }

    function test_DeleteTrainingReverts() public {
        vm.prank(trainingsCreator1);
        vm.expectRevert("TrainingsManager: Training not found");
        trainingsManager.deleteTraining("NonExistent");
    }

    function test_UpdateTraining() public {
        ITrainingsManager.TrainingInfo memory t = ITrainingsManager
            .TrainingInfo({
                name: "Training 1",
                description: "Old Description",
                durationInMinutes: 60,
                createdAt: 0
            });

        vm.startPrank(trainingsCreator1);
        trainingsManager.addTraining(t);

        ITrainingsManager.TrainingInfo[] memory before = trainingsManager
            .getTrainings(trainingsCreator1);
        uint256 originalCreatedAt = before[0].createdAt;
        assertGt(originalCreatedAt, 0);

        vm.expectEmit(true, true, false, true);
        emit ITrainingsManager.TrainingUpdated(t.name, trainingsCreator1);
        trainingsManager.updateTraining(t.name, "New Description", 90);

        ITrainingsManager.TrainingInfo[] memory after_ = trainingsManager
            .getTrainings(trainingsCreator1);
        assertEq(after_.length, 1);
        assertEq(after_[0].name, t.name);
        assertEq(after_[0].description, "New Description");
        assertEq(after_[0].durationInMinutes, 90);
        // createdAt should not change
        assertEq(after_[0].createdAt, originalCreatedAt);

        vm.stopPrank();
    }

    function test_UpdateTrainingReverts() public {
        vm.prank(trainingsCreator1);
        vm.expectRevert("TrainingsManager: Training not found");
        trainingsManager.updateTraining("NonExistent", "Desc", 30);
    }

    function test_GetTrainingCount() public {
        assertEq(trainingsManager.getTrainingCount(trainingsCreator1), 0);

        ITrainingsManager.TrainingInfo memory t = ITrainingsManager
            .TrainingInfo({
                name: "Training 1",
                description: "Description 1",
                durationInMinutes: 60,
                createdAt: 0
            });

        vm.startPrank(trainingsCreator1);
        trainingsManager.addTraining(t);
        assertEq(trainingsManager.getTrainingCount(trainingsCreator1), 1);

        trainingsManager.deleteTraining(t.name);
        assertEq(trainingsManager.getTrainingCount(trainingsCreator1), 0);
        vm.stopPrank();
    }
}
