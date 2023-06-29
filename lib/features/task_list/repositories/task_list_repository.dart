import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:simplify_the_task/data/api/dio_api.dart';
import 'package:simplify_the_task/data/utils/utils.dart';
import 'package:simplify_the_task/data/models/models.dart';
import 'package:simplify_the_task/data/repositories/repositories.dart';

// TODO(Decomposition the repositories)
class TaskListRepository {
  final Logger logger = Logger();
  late final IsarRepository _isarRepository;
  late final YandexRepository _yandexRepository;

  final String token;

  TaskListRepository({
    this.token = const String.fromEnvironment('yandex_api_key'),
    YandexRepository? yandexRepository,
    IsarRepository? isarRepository,
  }) {
    _yandexRepository = yandexRepository ?? _initYandexRepository();
    _isarRepository = isarRepository ?? _initIsarRepository();
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
    return YandexRepository(
      dio: dioApi.dio,
    );
  }

  IsarRepository _initIsarRepository() {
    return IsarRepository(
      appDirName: IsarConstants.directoryName,
    );
  }

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

  Future<List<TaskModel>> syncRepositories() async {
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
