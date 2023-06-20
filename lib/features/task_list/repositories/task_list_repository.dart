<<<<<<< HEAD
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:simplify_the_task/data/api/dio_api.dart';
import 'package:simplify_the_task/data/api/isar_api.dart';
import 'package:simplify_the_task/data/utils/utils.dart';
import 'package:simplify_the_task/data/models/models.dart';
import 'package:simplify_the_task/data/repositories/repositories.dart';

// TODO(Decomposition the repositories)
class TaskListRepository {
  final Logger logger = Logger();
  late final TaskListDataRepository _taskListDataRepository;
  final String token;

  TaskListRepository({
    this.token = const String.fromEnvironment('yandex_api_key'),
    TaskListDataRepository? taskListDataRepository,
  }) {
    _taskListDataRepository =
        taskListDataRepository ?? _initTaskListDataRepository();
  }

  TaskListDataRepository _initTaskListDataRepository() {
    final YandexRepository yandexRepository = _initYandexRepository();
    final IsarRepository isarRepository = _initIsarRepository();
    return TaskListDataRepository(
      isarRepository: isarRepository,
      yandexRepository: yandexRepository,
    );
  }

  YandexRepository _initYandexRepository() {
    final DioApi dioApi = DioApi(
      dio: Dio(
        BaseOptions(
          baseUrl: YandexConstants.baseUri,
          contentType: "application/json",
          headers: {
            'Authorization': 'Bearer $token',
            // 'X-Last-Known-Revision': lastKnownRevision,
          },
        ),
      ),
      interceptor: DioInterceptor(loger: logger),
    );
    return YandexRepository(dioApi: dioApi);
  }

  IsarRepository _initIsarRepository() {
    return IsarRepository(isarApi: IsarApi());
  }

  Future<List<TaskModel>> getTaskList() async {
    return await _taskListDataRepository.getTaskList();
  }

  Future<void> saveTask(TaskModel task) async {
    task = task.copyWith(changedAt: DateTime.now());
    return _taskListDataRepository.saveTask(task);
  }

  Future<void> deleteTask(TaskModel task) async {
    return _taskListDataRepository.deleteTask(task);
  }

  Future<List<TaskModel>> syncRepositories() async {
    return await _taskListDataRepository.syncRepositories();
  }

  Future<void> closeRepositories() async {
    await _taskListDataRepository.isarRepository.isarApi.closeIsar();
  }
}
=======
import 'package:logger/logger.dart';
import 'package:simplify_the_task/features/task_list/utils/isar_serializer.dart';
import 'package:simplify_the_task/features/task_list/utils/yandex_serializer.dart';
import 'package:simplify_the_task/models/task_model.dart';
import 'package:simplify_the_task/models/task_model_isar.dart';
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
>>>>>>> 435c830 (yandex repo)
