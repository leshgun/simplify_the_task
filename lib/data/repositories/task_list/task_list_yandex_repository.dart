import 'package:dio/dio.dart';
import 'package:simplify_the_task/data/api/dio_api.dart';
import 'package:simplify_the_task/data/models/models.dart';
import 'package:simplify_the_task/data/repositories/repositories.dart';
import 'package:simplify_the_task/data/utils/utils.dart';
import 'package:simplify_the_task/features/task_list/repositories/task_list_repository.dart';

class TaskListYandexRepository implements TaskListRepository {
  late YandexRepository yandexRepository;
  final String token;

  TaskListYandexRepository({this.token = ''}) {
    yandexRepository = _initYandexRepository();
  }

  @override
  Future<void> closeRepositories() async {}

  @override
  Future<void> deleteTask(TaskModel task) async {}

  @override
  Future<List<TaskModel>> getTaskList() async {
    final List<TaskModelYandex> list = await yandexRepository.getTaskList();
    return list.map((TaskModelYandex task) => YandexSerializer.toTaskModel(task)).toList();
  }

  @override
  Future<void> saveTask(TaskModel task) async {}

  @override
  Future<List<TaskModel>> syncRepositories() async {
    return [];
  }

  YandexRepository _initYandexRepository() {
    final DioApi dioApi = DioApi(
      dio: Dio(
        BaseOptions(
          baseUrl: YandexConstants.baseUri,
          contentType: "application/json",
          headers: {
            'Authorization': 'Bearer $token',
            'Access-Control-Allow-Origin': '*',
            // 'X-Last-Known-Revision': lastKnownRevision,
          },
        ),
      ),
      interceptor: DioInterceptor(),
    );
    return YandexRepository(dioApi: dioApi);
  }
}
