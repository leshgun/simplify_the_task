import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simplify_the_task/data/repositories/repositories.dart';

import '../task_list_test_constants.dart';

class MockIsarRepository extends Mock implements IsarRepository {}

class MockYandexRepository extends Mock implements YandexRepository {}

void main() {
  late MockIsarRepository mockIsarRepository;
  late MockYandexRepository mockYandexRepository;
  late TaskListDataRepository sut;

  void arrangeMockIsarRepository() {
    when(() => mockIsarRepository.getTaskList()).thenAnswer(
      (_) async => TaskListTestConstants.isarList,
    );
    when(
      () => mockIsarRepository.updateTask(any()),
    ).thenAnswer((_) async {});
  }

  setUp(() {
    registerFallbackValue(TaskListTestConstants.isarList.first);
    mockIsarRepository = MockIsarRepository();
    mockYandexRepository = MockYandexRepository();
    arrangeMockIsarRepository();
    sut = TaskListDataRepository(
      isarRepository: mockIsarRepository,
      yandexRepository: mockYandexRepository,
    );
  });

  test('GetTaskList', () async {
    final taskList = await sut.getTaskList();
    expect(taskList, TaskListTestConstants.taskList);
  });

  test('SaveTaskList', () async {
    final task = TaskListTestConstants.taskList.first;
    sut.saveTask(task);
    verify(() => mockIsarRepository.updateTask(any())).called(1);
  });
}
