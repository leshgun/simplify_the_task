import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simplify_the_task/data/models/task/task_model.dart';
import 'package:simplify_the_task/features/task_info/task_info_screen.dart';
import 'package:simplify_the_task/presentation/router/router.dart';

import './task_list_screen.dart';
export './task_list_screen.dart';

class TaskListRoute {
  final String name;
  final String path;
  final List<GoRoute> routes;
  final TaskListArguments? taskListArguments;

  const TaskListRoute({
    required this.name,
    required this.path,
    required this.routes,
    this.taskListArguments,
  });

  GoRoute getRoute() {
    return GoRoute(
      name: name,
      path: path,
      routes: routes,
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: TaskListScreen(taskListArguments: taskListArguments),
      ),
    );
  }

  static void showTaskInfo(BuildContext context, TaskModel task) {
    context.goNamed(
      Routes.task,
      pathParameters: {'id': task.id},
      extra: TaskInfoArguments(inputTask: task),
    );
  }

  static void createNewTask(BuildContext context) {
    context.goNamed(Routes.task, pathParameters: {'id': 'new'});
  }
}
