import 'package:dio/dio.dart';

class DioApi {
  final Dio dio;

  DioApi({required this.dio, InterceptorsWrapper? interceptor}) {
    if (interceptor != null) {
      dio.interceptors.add(interceptor);
    }
  }
}
