import 'package:simplify_the_task/data/models/task/task_model.dart';

abstract class TaskListRepository {
  Future<List<TaskModel>> getTaskList();
  Future<void> saveTask(TaskModel task);
  Future<void> deleteTask(TaskModel task);
  Future<List<TaskModel>> syncRepositories();
  Future<void> closeRepositories();
}