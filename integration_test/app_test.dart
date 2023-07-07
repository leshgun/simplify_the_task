@Tags(['integration'])

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

      final taskTile = find.byKey(Key('${taskList.first.id}_tile'));
      await tester.tap(taskTile);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 2));

      expect(find.byIcon(Icons.check_box), findsOneWidget);
    },
  );

  testWidgets(
    'Can add a new task',
    (WidgetTester tester) async {
      arrangeTaskListRepositoryMock(taskListRepositoryMock, taskList: taskList);
      test_app.runTestApp(repository: taskListRepositoryMock);

      await tester.pumpAndSettle();

      final taskNum =
          find.byIcon(Icons.check_box_outline_blank).evaluate().length;
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 2));

      final addTaskButton = find.byKey(const Key('add_task_btn'));
      await tester.tap(addTaskButton);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 2));

      final saveBtn = find.byKey(const Key('save_bth'));
      await tester.tap(saveBtn);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 2));

      verify(() => taskListRepositoryMock.saveTask(any())).called(1);
      expect(
        find.byIcon(Icons.check_box_outline_blank).evaluate().length,
        taskNum + 1,
      );
    },
  );
}
