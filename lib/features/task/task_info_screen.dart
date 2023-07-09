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
  final TaskInfoArguments? taskInfoArguments;

  const TaskInfoRoute({
    required this.name,
    required this.path,
    required this.routes,
    this.taskInfoArguments,
  });

  GoRoute getRoute() {
    const begin = Offset(0.0, 1.0);
    const end = Offset.zero;
    const curve = Curves.easeOutExpo;
    final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

    return GoRoute(
      name: name,
      path: path,
      routes: routes,
      pageBuilder: (context, state) {
        final task = state.queryParameters['task'];
        final extra = state.extra;
        TaskInfoArguments tia;
        if (extra == null) {
          tia = TaskInfoArguments(
              inputTask: task != null
                  ? TaskModel.fromBase64(task)
                      .copyWith(createdAt: DateTime.now())
                  : null,
              onSaveTask: taskInfoArguments?.onSaveTask);
        } else if (extra is TaskInfoArguments) {
          tia = extra;
        } else {
          tia = const TaskInfoArguments();
        }
        return CustomTransitionPage(
          key: state.pageKey,
          transitionDuration: const Duration(seconds: 1),
          reverseTransitionDuration: const Duration(seconds: 1),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          child: TaskInfoScreen(arguments: tia),
        );
      },
    );
  }
}
