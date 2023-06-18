import 'package:logger/logger.dart';
import 'package:simplify_the_task/features/task_list/utils/isar_serializer.dart';
import 'package:simplify_the_task/features/task_list/utils/yandex_serializer.dart';
import 'package:simplify_the_task/models/task_model.dart';
import 'package:simplify_the_task/models/task_model_isar.dart';
import 'package:simplify_the_task/models/task_model_yandex.dart';
import 'package:simplify_the_task/repositories/isar_repository.dart';
import 'package:simplify_the_task/repositories/yandex_repository.dart';

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
    _yandexRepository.getTaskList().then((List<TaskModelYandex> list) {
      logger.v('Task List on the Yandex Repository: $list');
    });

    return _getTaskListFromIsarRepository();
  }

  Future<void> saveTask(TaskModel task) async {
    _updateTaskInIsarRepository(task);
    // _yandexRepository.addToRepository([
    //   YandexSerializer.taskModelToTaskModelYandex(task),
    // ]);
  }

  Future<void> deleteTask(TaskModel task) async {
    _isarRepository.deleteTask(task.id);
  }

  Future<void> syncRepositories() async {
    List<TaskModelIsar> list = await _isarRepository.getTaskList();
    _yandexRepository.syncRepository(
      list.map((TaskModelIsar task) {
        final taskModel = IsarSerializer.taskModelIsarToTaskModel(task);
        return YandexSerializer.taskModelToTaskModelYandex(taskModel);
      }).toList(),
    );
  }

  Future<void> _updateTaskInIsarRepository(TaskModel task) async {
    _isarRepository.updateTask(IsarSerializer.taskModelToTaskModelIsar(task));
  }

  Future<List<TaskModel>> _getTaskListFromIsarRepository() async {
    final List<TaskModelIsar> list = await _isarRepository.getTaskList();
    return list
        .map((task) => IsarSerializer.taskModelIsarToTaskModel(task))
        .toList();
  }

  // List<TaskModel> _jsonListToTaskList(List<dynamic> json) {
  //   try {
  //     List<TaskModel> taskList = [];
  //     for (Map<String, dynamic> task in json) {
  //       taskList.add(TaskModel.fromJson(task));
  //     }
  //     return taskList;
  //   } catch (e) {
  //     logger.w('Cant deserialize Json!');
  //     logger.w(e);
  //   }
  //   return [];
  // }
}
