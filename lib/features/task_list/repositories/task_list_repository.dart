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
