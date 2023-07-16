@Tags(['widget'])

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../task_list_test_constants.dart';
import '../../test_app.dart';

void main() {
  late Widget testApp;
  late TaskListRepositoryMock taskListRepositoryMock;
  const arrangeTaskListRepositoryMock =
      TaskListTestConstants.arrangeTaskListRepositoryMock;

  setUp(() {
    registerFallbackValue(TaskListTestConstants.taskList.first);
    taskListRepositoryMock = TaskListRepositoryMock();
  });

  testWidgets('Visibility icon is here', (WidgetTester tester) async {
    arrangeTaskListRepositoryMock(taskListRepositoryMock);
    testApp = TestApp.build(repository: taskListRepositoryMock);

    await tester.pumpWidget(testApp);
    final findVisibility = find.byIcon(Icons.visibility);
    final findVisibilityOff = find.byIcon(Icons.visibility_off);
    final int count =
        findVisibility.evaluate().length + findVisibilityOff.evaluate().length;

    expect(count, greaterThan(0));
  });

  testWidgets('CircularProgressIndicator is here', (WidgetTester tester) async {
    arrangeTaskListRepositoryMock(
      taskListRepositoryMock,
      delay: const Duration(seconds: 1),
    );
    testApp = TestApp.build(repository: taskListRepositoryMock);

    await tester.pumpWidget(testApp);
    await tester.pump(const Duration(microseconds: 500));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpAndSettle();
  });
}
