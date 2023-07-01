import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simplify_the_task/data/models/models.dart';

import '../test/task_list/task_list_test_constants.dart';
import './test_main.dart' as test_app;

void main() {
  late TaskListRepositoryMock taskListRepositoryMock;
  const arrangeTaskListRepositoryMock =
      TaskListTestConstants.arrangeTaskListRepositoryMock;
  final List<TaskModel> taskList = TaskListTestConstants.taskList;

  setUp(() {
    registerFallbackValue(TaskListTestConstants.taskList.first);
    taskListRepositoryMock = TaskListRepositoryMock();
  });

  testWidgets(
    'Tapping on a task tile marks the task as completed',
    (WidgetTester tester) async {
      arrangeTaskListRepositoryMock(taskListRepositoryMock, taskList: taskList);
      test_app.runTestApp(repository: taskListRepositoryMock);

      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.check_box), findsNothing);
      await tester.pump(const Duration(seconds: 2));

      final taskTile = find.byKey(const Key('task_0_tile'));
      await tester.tap(taskTile);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 2));

      expect(find.byIcon(Icons.check_box), findsOneWidget);
    },
  );
}
