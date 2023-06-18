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
import 'package:simplify_the_task/features/task_list/utils/yandex_serializer.dart';
import 'package:simplify_the_task/models/task_model.dart';
import 'package:simplify_the_task/repositories/local_repository.dart';
import 'package:simplify_the_task/repositories/yandex_repository.dart';

class TaskListRepository {
  final Logger logger = Logger();
  final LocalRepository _localRepository =
      LocalRepository(directoryName: 'simplify_the_task');
  final YandexRepository _yandexRepository = YandexRepository(
    token: const String.fromEnvironment('yandex_api_key'),
  );

  Future<List<TaskModel>> getTaskList() async {
    return _getTaskListFromYandexRepository().then(
      (value) => _jsonToTaskList(value),
    );
  }

  void saveTaskList(List<TaskModel> taskList) async {
    for (TaskModel task in taskList) {
      _saveTaskToYandexRepository(task);
    }
  }

  void saveTask(TaskModel task) async {
    _saveTaskToYandexRepository(task);
  }

  void _saveTaskToYandexRepository(TaskModel task) async {
    logger.v(YandexSerializer.taskJsonToYandexJson(task));
    _yandexRepository.sendDataToRepository(
      '/list',
      YandexSerializer.taskJsonToYandexJson(task),
    );
  }

  Future<dynamic> _getTaskListFromYandexRepository() {
    return _yandexRepository.getDataByURL('/list').catchError((error) {
      logger.w('Unable to get data from the Yandex repository...');
      logger.v(error);
      return [];
    });
  }

  Future<dynamic> _getTaskListFromLocalRepository() {
    return _localRepository.readFromFile('task-list.json').catchError((error) {
      logger.w('Unable to get data from the Local repository...');
      logger.v(error);
      return '[]';
    });
  }

  List<TaskModel> _jsonToTaskList(List<dynamic> json) {
    try {
      // final decoded = jsonDecode(json);
      // if (decoded is! List<dynamic>) {
      //   return [];
      // }
      List<TaskModel> taskList = [];
      for (Map<String, dynamic> task in json) {
        taskList.add(TaskModel.fromJson(task));
      }
      return taskList;
    } catch (e) {
      logger.w('Cant deserialize Json!');
      logger.w(e);
    }
    return [];
  }
}
>>>>>>> 435c830 (yandex repo)
