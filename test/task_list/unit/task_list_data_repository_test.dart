@Tags(['unit'])

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simplify_the_task/data/repositories/repositories.dart';

import '../task_list_test_constants.dart';

void main() {
  late TaskListMultiRepository sut;
  late TaskListRepositoryMock firstRepo;
  late TaskListRepositoryMock secondRepo;

  void arrangeMockIsarRepository() {
    TaskListTestConstants.arrangeTaskListRepositoryMock(
      firstRepo,
      taskList: TaskListTestConstants.taskList,
    );
    TaskListTestConstants.arrangeTaskListRepositoryMock(
      secondRepo,
      taskList: TaskListTestConstants.taskList,
    );
  }

  setUp(() {
    registerFallbackValue(TaskListTestConstants.taskList.first);

    firstRepo = TaskListRepositoryMock();
    secondRepo = TaskListRepositoryMock();

    arrangeMockIsarRepository();
    sut = TaskListMultiRepository(
      repositoryList: [firstRepo, secondRepo],
    );
  });

  test('TaskList gets from the first repository.', () async {
    final taskList = await sut.getTaskList();
    verify(() => firstRepo.getTaskList()).called(1);
    expect(taskList, TaskListTestConstants.taskList);
  });

  test('SaveTask', () async {
    final task = TaskListTestConstants.taskList.first;
    sut.saveTask(task);
    verify(() => firstRepo.saveTask(any())).called(1);
  });

  test('SaveTaskList', () async {
    final taskList = TaskListTestConstants.taskList;
    sut.saveTaskList(taskList);
    verify(() => firstRepo.saveTaskList(any())).called(1);
  });
}
