import 'package:simplify_the_task/data/models/models.dart';
import 'package:simplify_the_task/data/utils/utils.dart';

import '../repositories.dart';

class TaskListDataRepository {
  late final IsarRepository isarRepository;
  late final YandexRepository yandexRepository;

  TaskListDataRepository({
    required this.isarRepository,
    required this.yandexRepository,
  });

  Future<List<TaskModel>> getTaskList() async {
    final List<TaskModelIsar> list = await isarRepository.getTaskList();
    final List<TaskModel> taskList =
        list.map((task) => IsarSerializer.toTaskModel(task)).toList();
    taskList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return taskList;
  }

  Future<void> saveTask(TaskModel task) async {
    isarRepository.updateTask(IsarSerializer.fromTaskModel(task));
  }

  Future<void> deleteTask(TaskModel task) async {
    isarRepository.deleteTask(task.id);
  }

  Future<List<TaskModel>> syncRepositories() async {
    List<TaskModelIsar> taskListIsar = await isarRepository.getTaskList();
    List<TaskModelYandex> taskListYandex;
    List<TaskModel> taskList = [];
    if (taskListIsar.isEmpty) {
      taskListYandex = await yandexRepository.getTaskList();
    } else {
      taskListYandex = await yandexRepository.mergeData(
        taskListIsar
            .map((TaskModelIsar task) =>
                YandexSerializer.fromTaskModelIsar(task))
            .toList(),
      );
    }
    if (taskListYandex.isEmpty) {
      taskList = taskListIsar
          .map((TaskModelIsar task) => IsarSerializer.toTaskModel(task))
          .toList();
    } else {
      taskList = taskListYandex
          .map((TaskModelYandex task) => YandexSerializer.toTaskModel(task))
          .toList();
      isarRepository.updateTaskList(taskListYandex
          .map((TaskModelYandex task) =>
              IsarSerializer.fromTaskModelYandex(task))
          .toList());
    }
    taskList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return taskList;
  }
}
