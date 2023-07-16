import 'dart:io';

import 'package:simplify_the_task/data/api/isar_api.dart';
import 'package:simplify_the_task/data/models/task/task_model.dart';
import 'package:simplify_the_task/data/repositories/repositories.dart';
import 'package:simplify_the_task/data/utils/utils.dart';
import 'package:simplify_the_task/features/task_list/repositories/task_list_repository.dart';

class TaskListIsarRepository implements TaskListRepository {
  TaskListIsarRepository({this.directory});

  final Directory? directory;
  final IsarRepository isarRepository = IsarRepository(isarApi: IsarApi());

  @override
  Future<void> closeRepositories() async {}

  @override
  Future<void> deleteTask(TaskModel task) async {
    isarRepository.deleteTask(task.id);
  }

  @override
  Future<List<TaskModel>> getTaskList() async {
    final list = await isarRepository.getTaskList();
    return list.map((task) => IsarSerializer.toTaskModel(task)).toList();
  }

  @override
  Future<void> saveTask(TaskModel task) async {
    isarRepository.updateTask(IsarSerializer.fromTaskModel(task));
  }

  @override
  Future<List<TaskModel>> syncRepositories() async {
    return [];
  }

  @override
  Future<void> saveTaskList(List<TaskModel> taskList) async {
    isarRepository.updateTaskList(
        taskList.map((task) => IsarSerializer.fromTaskModel(task)).toList());
  }
}
