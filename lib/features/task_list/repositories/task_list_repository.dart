import 'package:simplify_the_task/data/models/task/task_model.dart';

abstract class TaskListRepository {
  Future<void> closeRepositories();
  Future<void> deleteTask(TaskModel task);
  Future<List<TaskModel>> getTaskList();
  Future<void> saveTask(TaskModel task);
  Future<void> saveTaskList(List<TaskModel> taskList);
  Future<List<TaskModel>> syncRepositories();
}
