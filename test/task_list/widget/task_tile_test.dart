import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simplify_the_task/data/models/task/task_model.dart';

import '../task_list_test_constants.dart';
import '../../test_app.dart';

void main() {
  late Widget testApp;
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
      testApp = TestApp.build(repository: taskListRepositoryMock);

      await tester.pumpWidget(testApp);
      expect(find.byIcon(Icons.check_box), findsNothing);

      final taskTile = find.byKey(Key('${taskList.first.id}_tile'));
      await tester.pump(const Duration(microseconds: 500));

      await tester.tap(taskTile);
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.check_box), findsOneWidget);
    },
  );
}
