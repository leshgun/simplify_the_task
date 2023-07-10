import 'package:simplify_the_task/data/models/task/task_model.dart';

import 'task_list_repository.dart';

class TaskListRepositoryEmpty extends TaskListRepository {
  @override
  Future<void> closeRepositories() async {
    return;
  }

  @override
  Future<void> deleteTask(TaskModel task) async {
    return;
  }

  @override
  Future<List<TaskModel>> getTaskList() async {
    return [];
  }

  @override
  Future<void> saveTask(TaskModel task) async {
    return;
  }

  @override
  Future<List<TaskModel>> syncRepositories() async {
    return [];
  }
}
