// import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simplify_the_task/features/task/task_info_screen.dart';
import 'package:simplify_the_task/features/task_list/task_list_screen.dart';

class Routes {
  static const home = "home";
  static const task = "task";
  static const taskList = "task-list";
  static const unknown = "unknown";
}

class MyRouter {
  final GoRouter router = GoRouter(
    initialLocation: '/${Routes.taskList}',
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        name: Routes.home,
        path: '/',
        redirect: (context, state) => '/${Routes.taskList}',
        builder: (context, state) => const Center(
          child: Text('Hello there...'),
        ),
      ),
      TaskListRoute(
        name: Routes.taskList,
        path: '/${Routes.taskList}',
        routes: [
          const TaskInfoRoute(
            name: Routes.task,
            path: ':id',
            routes: [],
          ).getRoute(),
        ],
      ).getRoute()
    ],
  );

  // static GoRoute taskListRoute = GoRoute(
  //   name: Routes.taskList,
  //   path: '/${Routes.taskList}',
  //   pageBuilder: (context, state) => MaterialPage(
  //     key: state.pageKey,
  //     child: const TaskListScreen(),
  //   ),
  //   routes: [taskRoute],
  // );

  // static GoRoute taskRoute = GoRoute(
  //   name: Routes.task,
  //   path: ':id',
  //   pageBuilder: (context, state) {
  //     final task = state.queryParameters['task'];
  //     final extra = state.extra;
  //     TaskInfoArguments tia;
  //     if (extra == null) {
  //       tia = TaskInfoArguments(
  //         inputTask: task != null ? TaskModel.fromBase64(task) : null,
  //       );
  //     } else if (extra is TaskInfoArguments) {
  //       tia = extra;
  //     } else {
  //       tia = const TaskInfoArguments();
  //     }
  //     return MaterialPage(
  //       key: state.pageKey,
  //       child: TaskInfoScreen(arguments: tia),
  //     );
  //   },
  // );
}

// final router = GoRouter(
//   initialLocation: '/task-list',
//   debugLogDiagnostics: true,
//   routes: [
//     GoRoute(
//       path: '/',
//       builder: (context, state) => const TaskListScreen(),
//     ),
//     GoRoute(
//       path: '/task-list',
//       builder: (context, state) => const TaskListScreen(),
//     ),
//     GoRoute(
//       path: '/task-info',
//       builder: (context, state) {
//         final args = state.extra;
//         if (args is! TaskInfoArguments) {
//           Logger().w('Wrong arguments for screen "task-info"');
//           return const TaskListScreen();
//         }
//         return TaskInfoScreen(arguments: args);
//       },
//     ),
//     GoRoute(
//       path: '/task/:task',
//       builder: (context, state) {
//         final taskBase64 = state.pathParameters['task'];
//         if (taskBase64 == null) {
//           return const TaskListScreen();
//         }
//         try {
//           Logger().w('Trying to decode the task...');
//           TaskModel task = TaskModel.fromBase64(taskBase64);
//           Logger().w('Deserialized task', task);
//           return TaskInfoScreen(
//             arguments: TaskInfoArguments(
//               inputTask: task,
//               onSaveTask: (task) => context.go('/task-list'),
//               onUpdateTask: (task) => context.go('/task-list'),
//               onDeleteTask: (task) => context.go('/task-list'),
//             ),
//           );
//         } catch (e, stacktrace) {
//           Logger().w(
//             'Cant decode the deeplink',
//             '$taskBase64\n${utf8.decode(base64Decode(taskBase64))}\n$e',
//             stacktrace,
//           );
//           return const TaskListScreen();
//         }
//       },
//     ),
//   ],
// );

// TaskInfoArguments getArgsFromDeeplink(BuildContext context, String args) {
//   return TaskInfoArguments(
//     inputTask: TaskModel.fromBase64(args),
//     onSaveTask: (task) => context.go('/task-list'),
//     onUpdateTask: (task) => context.go('/task-list'),
//     onDeleteTask: (task) => context.go('/task-list'),
//   );
// }
