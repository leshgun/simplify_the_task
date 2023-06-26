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
      validateStatus: _validateStatus,
    );
  }

  // TODO: code review
  Future<List<TaskModelYandex>> getTaskList() async {
    final Response? response = await _get('/list');
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
    return await dio.get(url).then(
      (Response response) {
        _updateRevision(response);
        logger.v('The response from the repository was successfully received.');
        return response;
      },
      onError: (error) {
        logger.w('The response from the repository cannot by recieved.', error);
        return;
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

  // ignore: unused_element
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

  Future<dynamic> _patch(String url, String data) async {
    return dio.patch(url, data: data).then(
      (value) {
        logger.v('Data in the Yandex repository patched successfully');
        return value;
      },
      onError: (error) {
        logger.w('The data cannot be patched in the Yandex repository', error);
      },
    );

    // return await dio.patch(url, data: data).then(
    //   (Response response) {
    //     _updateRevision(response);
    //     logger.v('Data in the Yandex repository patched successfully');
    //     logger.w(response.data);
    //     return response;
    //   },
    //   onError: (error) {
    //     logger.w('The data cannot be patched in the Yandex repository', error);
    //   },
    // );
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

// class MyHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext? context) {
//     return super.createHttpClient(context)
//       ..badCertificateCallback =
//           (X509Certificate cert, String host, int port) => true;
//   }
// }
