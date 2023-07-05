import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:simplify_the_task/data/api/dio_api.dart';
import 'package:simplify_the_task/data/models/yandex/task_model_yandex.dart';

import './yandex_constants.dart';

const Duration deleay = Duration(microseconds: 300);

class YandexRepository {
  final Logger logger = Logger();
  final DioApi dioApi;
  int lastKnownRevision;

  YandexRepository({required this.dioApi, this.lastKnownRevision = -1}) {
    // if (lastKnownRevision < 0) {
    //   _updateRevision();
    // }
  }

  Options get dioOptions {
    final headers = dioApi.dio.options.headers;
    headers['X-Last-Known-Revision'] = lastKnownRevision;
    return Options(headers: headers);
  }

  // TODO: code reveiw needed
  Future<List<TaskModelYandex>> getTaskList() async {
    final response = await _get(YandexConstants.taskListUri);
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
    _updateRevision();
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
      await _post(
        YandexConstants.taskListUri,
        jsonEncode({"element": task.toJson()}),
      );
      Future.delayed(deleay);
    }
  }

  Future<Response?> updateListOnRepository(List<TaskModelYandex> list) async {
    return await _patch(
      YandexConstants.taskListUri,
      jsonEncode({"list": list.map((task) => task.toJson()).toList()}),
    );
  }

  Future<void> deleteFromRepository(List<dynamic> list) async {
    if (list.isEmpty) {
      return;
    }
    for (final taskId in list) {
      await _delete('${YandexConstants.taskListUri}/$taskId');
      Future.delayed(deleay);
    }
  }

  Future<Response?> _get(String url) async {
    try {
      final Response response = await dioApi.dio.get(url);
      await _updateRevision(response.data['revision']);
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
    await dioApi.dio.post(url, data: data, options: dioOptions).then(
      (Response response) {
        _updateRevision(response.data['revision']);
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
    await dioApi.dio.put(url, data: data, options: dioOptions).then(
      (Response response) {
        _updateRevision(response.data['revision']);
        _onResponse(
            'Data changed in the Yandex repository successfully', response);
      },
      onError: (error) {
        _onError('The data in the Yandex repository cannot be changed', error);
      },
    );
  }

  Future<void> _delete(String url) async {
    await dioApi.dio.delete(url, options: dioOptions).then(
      (Response response) {
        _updateRevision(response.data['revision']);
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
    await _updateRevision();
    try {
      final response = await dioApi.dio.patch(
        url,
        data: data,
        options: dioOptions,
      );
      await _updateRevision(response.data['revision']);
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

  Future<int?> _getRevision() async {
    Response? response;
    try {
      response = await dioApi.dio.get(YandexConstants.taskListUri);
    } catch (e, stacktrace) {
      logger.w('Cant update the revision', e, stacktrace);
      return null;
    }
    if (response.statusCode != 200) {
      return null;
    }
    final revision = response.data['revision'];
    if (revision == null) {
      return null;
    }
    if (revision is! int) {
      return null;
    }
    return revision;
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

  Future<void> _updateRevision([int? revision]) async {
    revision ??= await _getRevision();
    lastKnownRevision = revision ?? lastKnownRevision;
    logger.v('Last known revision: $revision');
  }
}
