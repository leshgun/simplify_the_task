import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:simplify_the_task/data/models/task_model_yandex.dart';

const String baseURL = 'https://beta.mrdekk.ru/todobackend';
const Duration deleay = Duration(microseconds: 300);

class YandexRepository {
  final Logger logger = Logger();
  final Dio dio = Dio();
  final String? token;
  int lastKnownRevision = 0;

  YandexRepository({this.token}) {
    updateDioOptions();
  }

  void updateDioOptions() {
    dio.options = BaseOptions(
      baseUrl: baseURL,
      contentType: "application/json",
      headers: {
        'Authorization': 'Bearer ${token ?? ''}',
        'X-Last-Known-Revision': lastKnownRevision,
      },
    );
  }

  // TODO: code review
  Future<List<TaskModelYandex>> getTaskList() async {
    final response = await _get('/list');
    if (response == null) {
      return [];
    }
    if (response.statusCode != 200) {
      return [];
    }
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      return [];
    }
    final list = data['list'];
    if (list == null || list is! List) {
      return [];
    }
    return list.map((json) => TaskModelYandex.fromJson(json)).toList();
  }

  Future<List<TaskModelYandex>> mergeData(List<TaskModelYandex> list) async {
    _updateRevision(null);
    final Response? response = await updateListOnRepository(list);
    if (response == null) {
      return list;
    }
    final data = response.data;
    if (data == null) {
      return list;
    }
    final newList = data['list'];
    if (newList == null || newList is! List) {
      return list;
    }
    return newList.map((json) => TaskModelYandex.fromJson(json)).toList();
  }

  Future<void> addToRepository(List<TaskModelYandex> list) async {
    if (list.isEmpty) {
      return;
    }
    for (TaskModelYandex task in list) {
      await _post('/list', jsonEncode({"element": task.toJson()}));
      Future.delayed(deleay);
    }
  }

  Future<Response?> updateListOnRepository(List<TaskModelYandex> list) async {
    return await _patch(
      '/list',
      jsonEncode({"list": list.map((task) => task.toJson()).toList()}),
    );
  }

  Future<void> deleteFromRepository(List<dynamic> list) async {
    if (list.isEmpty) {
      return;
    }
    for (final taskId in list) {
      await _delete('/list/$taskId');
      Future.delayed(deleay);
    }
  }

  Future<Response?> _get(String url) async {
    try {
      final Response response = await dio.get(url);
      _updateRevision(response);
      _onResponse(
        'The response from the repository was successfully received.',
        response,
      );
      return response;
    } on DioException catch (e) {
      // logger.w('The response from the repository cannot by recieved.');
      _onError('The response from the repository cannot by recieved.', e);
    }
    return null;
  }

  Future<void> _post(String url, String data) async {
    await dio.post(url, data: data).then(
      (Response response) {
        _updateRevision(response);
        _onResponse(
          'Data send to the Yandex repository successfully',
          response,
        );
      },
      onError: (error) {
        _onError('The data cannot be sended to the Yandex repository', error);
      },
    );
  }

  // ignore: unused_element
  Future<void> _put(String url, String data) async {
    await dio.put(url, data: data).then(
      (Response response) {
        _updateRevision(response);
        _onResponse(
            'Data changed in the Yandex repository successfully', response);
      },
      onError: (error) {
        _onError('The data in the Yandex repository cannot be changed', error);
      },
    );
  }

  Future<void> _delete(String url) async {
    await dio.delete(url).then(
      (Response response) {
        _updateRevision(response);
        _onResponse(
          'Data deleted from the Yandex repository successfully',
          response,
        );
      },
      onError: (error) {
        _onError(
          'The data cannot be deleted from the Yandex repository',
          error,
        );
      },
    );
  }

  Future<Response?> _patch(String url, String data) async {
    try {
      final Response response = await dio.patch(url, data: data);
      _updateRevision(response);
      _onResponse(
        'Data in the Yandex repository patched successfully',
        response,
      );
      return response;
    } on DioException catch (e) {
      _onError('The data cannot be patched in the Yandex repository', e);
    }
    return null;
  }

  void _onResponse(String text, Response? response) {
    logger.v(
      text,
      '${response?.statusCode}\n${response?.realUri}\n${response?.headers}',
    );
  }

  void _onError(String text, dynamic error) {
    logger.w(text, error);
  }

  Future<void> _updateRevision(Response? response) async {
    response ??= await _get('/list');
    if (response == null) {
      return;
    }
    if (response.statusCode != 200) {
      return;
    }
    final revision = response.data['revision'];
    if (revision is int) {
      lastKnownRevision = revision;
      updateDioOptions();
      logger.v('Last known revision: $revision');
    }
  }
}
