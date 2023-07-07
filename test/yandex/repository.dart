// import 'package:dio/dio.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:simplify_the_task/data/api/dio_api.dart';
// import 'package:simplify_the_task/data/repositories/yandex/yandex.dart';

// import 'yandex_text_constants.dart';

// class MockDio extends Mock implements Dio {}

// void main() {
//   late DioApi dioApi;
//   late MockDio mockDio;
//   late YandexRepository yandexRepository;

//   void arrangeMockDio() {
//     when(() => mockDio.options).thenReturn(BaseOptions(headers: {}));
//     when(() => mockDio.get(YandexConstants.taskListUri)).thenAnswer(
//       (_) async => Response(
//         requestOptions: RequestOptions(),
//         data: YandexTestConstants.getList,
//         statusCode: 200,
//       ),
//     );
//   }

//   setUp(() {
//     mockDio = MockDio();
//     arrangeMockDio();
//     dioApi = DioApi(dio: mockDio);
//     yandexRepository = YandexRepository(dioApi: dioApi);
//   });

//   group('Revision', () {
//     late Options options;

//     setUp(() {
//       options = yandexRepository.dioOptions;
//     });
//     test(
//       'Headers contains revision',
//       () {
//         expect(options.headers?.containsKey('X-Last-Known-Revision'), true);
//       },
//     );

//     test('Init revision is -1', () {
//       expect(options.headers?['X-Last-Known-Revision'], -1);
//     });

//     test('The revision after the GET request has been updated', () async {
//       await yandexRepository.getTaskList();
//       options = yandexRepository.dioOptions;
//       expect(
//         options.headers?['X-Last-Known-Revision'],
//         YandexTestConstants.getList['revision'],
//       );
//     });
//   });
// }
