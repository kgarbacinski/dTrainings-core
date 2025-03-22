import "../src/trainings/logic/TrainingsManager.sol";
import "lib/forge-std/src/Test.sol";
import "../src/trainings/logic/ITrainingsManager.sol";

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
                durationInMinutes: 60
            });
        ITrainingsManager.TrainingInfo memory trainingInfo2 = ITrainingsManager
            .TrainingInfo({
                name: "Training 2",
                description: "Description 2",
                durationInMinutes: 120
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

        ITrainingsManager.TrainingInfo[] memory trainings2 = trainingsManager
            .getTrainings(trainingsCreator2);
        assertEq(trainings2.length, 1);
        assertEq(trainings2[0].name, trainingInfo2.name);
        assertEq(trainings2[0].description, trainingInfo2.description);
        assertEq(
            trainings2[0].durationInMinutes,
            trainingInfo2.durationInMinutes
        );
    }

    function test_AddTrainingReverts() public {
        ITrainingsManager.TrainingInfo memory trainingInfo1 = ITrainingsManager
            .TrainingInfo({
                name: "Training 1",
                description: "Description 1",
                durationInMinutes: 60
            });
        ITrainingsManager.TrainingInfo memory trainingInfo2 = ITrainingsManager
            .TrainingInfo({
                name: "Training 1", // A user wants to create a training with already existing name
                description: "Description 2",
                durationInMinutes: 120
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
        ITrainingsManager.TrainingInfo memory trainingInfo = ITrainingsManager
            .TrainingInfo({
                name: "Training 1",
                description: "Description 1",
                durationInMinutes: 60
            });

        vm.prank(trainingsCreator1);
        trainingsManager.addTraining(trainingInfo);

        ITrainingsManager.TrainingInfo[] memory trainings = trainingsManager
            .getTrainings(trainingsCreator1);
        assertEq(trainings.length, 1);
        assertEq(trainings[0].name, trainingInfo.name);
        assertEq(trainings[0].description, trainingInfo.description);
        assertEq(
            trainings[0].durationInMinutes,
            trainingInfo.durationInMinutes
        );

        vm.prank(trainingsCreator1);

        vm.expectEmit(true, true, false, true);
        emit ITrainingsManager.TrainingDeleted(
            trainingInfo.name,
            trainingsCreator1
        );

        trainingsManager.deleteTraining(trainingInfo.name);
    }
}
