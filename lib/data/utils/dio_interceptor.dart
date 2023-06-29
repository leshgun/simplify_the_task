import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class DioInterceptor extends InterceptorsWrapper {
  Logger? loger;

  DioInterceptor({this.loger});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // TODO: implement onRequest
    loger?.v('Dio (${options.method}) Request', options.headers);
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // TODO: implement onResponse
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
