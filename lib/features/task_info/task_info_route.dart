import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simplify_the_task/data/models/task/task_model.dart';
import 'package:simplify_the_task/features/task_info/task_info_screen.dart';
import 'package:simplify_the_task/presentation/router/router.dart';

export 'task_info_screen.dart';

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
        TaskInfoArguments? tia = taskInfoArguments;
        if ((extra is TaskInfoArguments) && (extra.inputTask != null)) {
          tia = tia?.copyWith(inputTask: extra.inputTask);
        } else if (task != null) {
          tia = tia?.copyWith(
            inputTask: TaskModel.fromBase64(task).copyWith(
              createdAt: DateTime.now(),
            ),
          );
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

  static void popScreen(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.goNamed(Routes.taskList);
    }
  }
}
