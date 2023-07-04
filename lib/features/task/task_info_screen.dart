import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simplify_the_task/data/models/task/task_model.dart';

import 'task_info.dart';

class TaskInfoScreen extends StatelessWidget {
  final TaskInfoArguments? arguments;

  const TaskInfoScreen({super.key, this.arguments});

  @override
  Widget build(BuildContext context) {
    // final arguments = ModalRoute.of(context)!.settings.arguments;
    return TaskInfo(
      arguments: arguments is TaskInfoArguments ? arguments : null,
    );
  }
}

class TaskInfoArguments {
  final Function(TaskModel task)? onSaveTask;
  final Function(TaskModel task)? onUpdateTask;
  final Function(TaskModel task)? onDeleteTask;
  final TaskModel? inputTask;

  const TaskInfoArguments({
    this.onSaveTask,
    this.onUpdateTask,
    this.onDeleteTask,
    this.inputTask,
  });
}

class TaskInfoRoute {
  final String name;
  final String path;
  final List<GoRoute> routes;

  const TaskInfoRoute({
    required this.name,
    required this.path,
    required this.routes,
  });

  GoRoute getRoute() {
    return GoRoute(
      // name: Routes.task,
      // path: ':id',
      name: name,
      path: path,
      routes: routes,
      pageBuilder: (context, state) {
        final task = state.queryParameters['task'];
        final extra = state.extra;
        TaskInfoArguments tia;
        if (extra == null) {
          tia = TaskInfoArguments(
            inputTask: task != null ? TaskModel.fromBase64(task) : null,
          );
        } else if (extra is TaskInfoArguments) {
          tia = extra;
        } else {
          tia = const TaskInfoArguments();
        }
        return MaterialPage(
          key: state.pageKey,
          // child: TaskInfoScreen(arguments: tia),
          child: TaskInfoScreen(arguments: tia),
        );
      },
    );
  }
}
