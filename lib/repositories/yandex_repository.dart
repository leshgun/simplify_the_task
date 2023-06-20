import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:simplify_the_task/models/task_model_yandex.dart';

const String baseURL = 'https://beta.mrdekk.ru/todobackend';
const Duration deleay = Duration(microseconds: 300);

class YandexRepository {
  final Logger logger = Logger();
  final Dio dio = Dio();
  final String? token;

  YandexRepository({this.token}) {
    HttpOverrides.global = MyHttpOverrides();
    dio.options = BaseOptions(
      baseUrl: baseURL,
      contentType: "application/json",
      headers: {'Authorization': 'Bearer ${token ?? ''}'},
      validateStatus: _validateStatus,
    );
  }

  // TODO: code review
  Future<List<TaskModelYandex>> getTaskList() async {
    final Response response = await _get('/list');
    if (response.statusCode == 200) {
      final data = response.data;
      if (data is List) {
        return data.map((json) => TaskModelYandex.fromJson(json)).toList();
      }
    }
    return [];
  }

  Future<void> syncRepository(List<TaskModelYandex> list) async {
    final Response response = await dio.get('/list');
    if (response.statusCode != 200) {
      return;
    }
    _updateRevision(response);
    final data = response.data['list'] as List;
    List<dynamic> listToDelete =
        data.map((json) => json['id'].toString()).toList();
    List<TaskModelYandex> listToAdd = [];
    List<TaskModelYandex> listToUpdate = [];
    for (TaskModelYandex task in list) {
      if (listToDelete.contains(task.id)) {
        final taskToDelete = data.firstWhere((t) => t['id'] == task.id);
        if (task.changedAt != taskToDelete['changed_at']) {
          listToUpdate.add(task);
        }
        listToDelete.remove(task.id);
      } else {
        listToAdd.add(task);
      }
    }
    await deleteFromRepository(listToDelete);
    await updateListOnRepository(listToUpdate);
    await addToRepository(listToAdd);
    logger.v('Synchronization was successful');
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

  Future<void> updateListOnRepository(List<TaskModelYandex> list) async {
    if (list.isEmpty) {
      return;
    }
    for (TaskModelYandex task in list) {
      await _put('/list/${task.id}', jsonEncode({"element": task.toJson()}));
      Future.delayed(deleay);
    }
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

  Future<void> updateTheRepository() async {
    _patch('/lsit');
  }

  Future<Response> _get(String url) async {
    return await dio.get(url).then(
      (Response response) {
        _updateRevision(response);
        logger.v('The response from the repository was successfully received.');
        return response;
      },
      onError: (error) {
        logger.w('The response from the repository cannot by recieved.', error);
      },
    );
  }

  Future<void> _post(String url, String data) async {
    await dio.post(url, data: data).then(
      (Response response) {
        _updateRevision(response);
        logger.v('Data send to the Yandex repository successfully');
      },
      onError: (error) {
        logger.w('The data cannot be sended to the Yandex repository', error);
      },
    );
  }

  Future<void> _put(String url, String data) async {
    await dio.put(url, data: data).then(
      (Response response) {
        _updateRevision(response);
        logger.v('Data changed in the Yandex repository successfully');
      },
      onError: (error) {
        logger.w('The data in the Yandex repository cannot be changed', error);
      },
    );
  }

  Future<void> _delete(String url) async {
    await dio.delete(url).then(
      (Response response) {
        _updateRevision(response);
        logger.v('Data deleted from the Yandex repository successfully');
      },
      onError: (error) {
        logger.w(
            'The data cannot be deleted from the Yandex repository', error);
      },
    );
  }

  Future<void> _patch(String url) async {
    await dio.patch(url).then(
      (Response response) {
        _updateRevision(response);
        logger.v('Data in the Yandex repository patched successfully');
      },
      onError: (error) {
        logger.w('The data cannot be patched in the Yandex repository');
        logger.w(error);
      },
    );
  }

  Future<void> _updateRevision(Response? response) async {
    response ??= await _get('list');
    final revision = response.data['revision'];
    if (revision is int) {
      // Maybe sometimes....
      // final int oldRevision =
      //     dio.options.headers['X-Last-Known-Revision'] ?? (revision - 1);
      // if (revision - oldRevision > 1) {
      //   syncRepository();
      // }
      dio.options.headers['X-Last-Known-Revision'] = revision;
      logger.v('Last known revision: $revision');
    }
  }

  bool _validateStatus(int? status) {
    if (status == null) {
      return false;
    }
    if (status > 200) {
      logger.wtf('WTF with status?: $status');
      return false;
    }
    return true;
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}