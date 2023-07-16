import 'package:mocktail/mocktail.dart';
import 'package:simplify_the_task/data/models/models.dart';
import 'package:simplify_the_task/features/task_list/repositories/task_list_repository.dart';

// import 'widget/task_list_test.dart';

class TaskListRepositoryMock extends Mock implements TaskListRepository {}

class TaskListTestConstants {
  static final List<TaskModel> taskList = [
    TaskModel(
      id: '0',
      text: 'some text of 0',
      completed: false,
      createdAt: DateTime.parse('2023-07-01'),
      changedAt: DateTime.parse('2023-07-01'),
    ),
    TaskModel(
      id: '1',
      text: 'some text of 1',
      completed: false,
      priority: 0,
      createdAt: DateTime.parse('2023-07-01'),
      changedAt: DateTime.parse('2023-07-01'),
    ),
  ];

  static void arrangeTaskListRepositoryMock(
    TaskListRepositoryMock mock, {
    Duration? delay,
    List<TaskModel>? taskList,
  }) {
    when(() => mock.getTaskList()).thenAnswer((_) async {
      if (delay != null) await Future.delayed(delay);
      return taskList ?? [];
    });
    when(() => mock.deleteTask(any())).thenAnswer((_) async {
      if (delay != null) await Future.delayed(delay);
    });
    when(() => mock.saveTask(any())).thenAnswer((_) async {
      if (delay != null) await Future.delayed(delay);
    });
    when(() => mock.saveTaskList(any())).thenAnswer((_) async {
      if (delay != null) await Future.delayed(delay);
    });
    when(() => mock.syncRepositories()).thenAnswer((_) async {
      if (delay != null) await Future.delayed(delay);
      return taskList ?? [];
    });
  }
}
