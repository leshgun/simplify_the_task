import 'dart:io';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

const String baseURL = 'https://beta.mrdekk.ru/todobackend';

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

  Future<dynamic> getDataByURL(String url) {
    return dio.get(url).then((Response response) {
      logger.v('Response from "${response.realUri}": $response');
      if (response.statusCode == 200) {
        _updateRevision(response);
        return response.data['list'] ?? [];
      }
    }).catchError((error) {
      logger.w('Kono Dio Da: $error');
      return [];
    });
  }

  void sendDataToRepository(String url, Map<String, dynamic> data) async {
    logger.v(dio.options.headers);
    dio.post(url, data: data, options: Options()).then(
      (Response response) {
        logger.v(response);
      },
      onError: (error) {
        logger.w(error);
      },
    );
  }

  void _updateRevision(Response response) async {
    final revision = response.data['revision'];
    if (revision is int) {
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
