import 'package:simplify_the_task/data/models/task/task_model.dart';

import 'task_list_repository.dart';

class TaskListRepositoryEmpty extends TaskListRepository {
  @override
  Future<void> closeRepositories() async {}

  @override
  Future<void> deleteTask(TaskModel task) async {}

  @override
  Future<List<TaskModel>> getTaskList() async => [];

  @override
  Future<void> saveTask(TaskModel task) async {}

  @override
  Future<List<TaskModel>> syncRepositories() async => [];

  @override
  Future<void> saveTaskList(List<TaskModel> taskList) async {}
}
