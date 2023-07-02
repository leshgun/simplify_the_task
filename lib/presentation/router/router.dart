import 'dart:convert';

import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:simplify_the_task/data/models/models.dart';
import 'package:simplify_the_task/features/task/task_info_screen.dart';
import 'package:simplify_the_task/features/task_list/task_list_screen.dart';

// final routes = {
//   '/task-list': (context) => const TaskListScreen(),
//   '/task-info': (context) => const TaskInfoScreen(),
// };

final router = GoRouter(
  initialLocation: '/task-list',
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const TaskListScreen(),
    ),
    GoRoute(
      path: '/task-list',
      builder: (context, state) => const TaskListScreen(),
    ),
    GoRoute(
      path: '/task-info',
      builder: (context, state) {
        final args = state.extra;
        if (args is! TaskInfoArguments) {
          Logger().w('Wrong arguments for screen "task-info"');
          return const TaskListScreen();
        }
        return TaskInfoScreen(arguments: args);
      },
    ),
    GoRoute(
      path: '/task/:task',
      builder: (context, state) {
        final taskBase64 = state.pathParameters['task'];
        if (taskBase64 == null) {
          return const TaskListScreen();
        }
        try {
          Logger().w('Trying to decode the task...');
          TaskModel task = TaskModel.fromBase64(taskBase64);
          Logger().w('Deserialized task', task);
          return TaskInfoScreen(
            arguments: TaskInfoArguments(
              inputTask: task,
              onSaveTask: (task) => context.go('/task-list'),
              onUpdateTask: (task) => context.go('/task-list'),
              onDeleteTask: (task) => context.go('/task-list'),
            ),
          );
        } catch (e, stacktrace) {
          Logger().w(
            'Cant decode the deeplink',
            '$taskBase64\n${utf8.decode(base64Decode(taskBase64))}\n$e',
            stacktrace,
          );
          return const TaskListScreen();
        }
      },
    ),
  ],
);

// TaskInfoArguments getArgsFromDeeplink(BuildContext context, String args) {
//   return TaskInfoArguments(
//     inputTask: TaskModel.fromBase64(args),
//     onSaveTask: (task) => context.go('/task-list'),
//     onUpdateTask: (task) => context.go('/task-list'),
//     onDeleteTask: (task) => context.go('/task-list'),
//   );
// }
