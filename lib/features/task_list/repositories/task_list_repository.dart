import 'package:logger/logger.dart';
import 'package:simplify_the_task/features/task_list/utils/isar_serializer.dart';
import 'package:simplify_the_task/features/task_list/utils/yandex_serializer.dart';
import 'package:simplify_the_task/data/models/task_model.dart';
import 'package:simplify_the_task/data/models/task_model_isar.dart';
import 'package:simplify_the_task/data/models/task_model_yandex.dart';
import 'package:simplify_the_task/data/repositories/isar_repository.dart';
import 'package:simplify_the_task/data/repositories/yandex_repository.dart';

const directoryName = 'simplify_the_task';

class TaskListRepository {
  final Logger logger = Logger();
  final IsarRepository _isarRepository = IsarRepository(
    directoryName: directoryName,
  );
  final YandexRepository _yandexRepository = YandexRepository(
    token: const String.fromEnvironment('yandex_api_key'),
  );

  Future<List<TaskModel>> getTaskList() async {
    return _getTaskListFromIsarRepository();
  }

  Future<void> saveTask(TaskModel task) async {
    task = task.copyWith(changedAt: DateTime.now());
    _updateTaskInIsarRepository(task);
  }

  Future<void> deleteTask(TaskModel task) async {
    _isarRepository.deleteTask(task.id);
  }

  Future<List<TaskModel>> syncRepositories({bool isMerge = false}) async {
    List<TaskModelIsar> taskListIsar = await _isarRepository.getTaskList();
    List<TaskModelYandex> taskListYandex;
    List<TaskModel> taskList = [];
    if (taskListIsar.isEmpty) {
      taskListYandex = await _yandexRepository.getTaskList();
    } else {
      taskListYandex = await _yandexRepository.mergeData(
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
      _isarRepository.updateTaskList(taskListYandex
          .map((TaskModelYandex task) =>
              IsarSerializer.fromTaskModelYandex(task))
          .toList());
    }
    taskList.sort((a, b) => b.changedAt.compareTo(a.createdAt));
    return taskList;
  }

  Future<void> _updateTaskInIsarRepository(TaskModel task) async {
    _isarRepository.updateTask(IsarSerializer.fromTaskModel(task));
  }

  Future<List<TaskModel>> _getTaskListFromIsarRepository() async {
    final List<TaskModelIsar> list = await _isarRepository.getTaskList();
    final List<TaskModel> taskList =
        list.map((task) => IsarSerializer.toTaskModel(task)).toList();
    taskList.sort((a, b) => b.changedAt.compareTo(a.createdAt));
    return taskList;
  }
}
