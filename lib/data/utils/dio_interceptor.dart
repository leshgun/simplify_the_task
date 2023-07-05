import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class DioInterceptor extends InterceptorsWrapper {
  Logger? loger;

  DioInterceptor({this.loger});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    loger?.v('Dio (${options.method}) Request',
        '${options.uri}\n${options.headers}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    loger?.v(
      'Dio Response (${response.statusCode})',
      '${response.realUri} \n${response.headers}',
    );
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    loger?.w(
      'Error on Dio (${err.requestOptions.method}) Request',
      '$err \n${err.requestOptions.headers}',
    );
    super.onError(err, handler);
  }
}
