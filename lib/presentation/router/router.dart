import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simplify_the_task/di/task_list_di.dart';
import 'package:simplify_the_task/features/task_info/task_info_route.dart';
import 'package:simplify_the_task/features/task_list/task_list_route.dart';
import 'package:simplify_the_task/presentation/widgets/custom_banner.dart';

class Routes {
  static const home = "home";
  static const task = "task";
  static const taskList = "task-list";
  static const unknown = "unknown";
}

class MyRouter {
  final String? bannerText;
  late GoRouter router;

  MyRouter({this.bannerText}) {
    _initRouter();
  }

  void _initRouter() {
    final taskListDI = TaskListDI();
    router = GoRouter(
      initialLocation: '/${Routes.taskList}',
      debugLogDiagnostics: true,
      routes: [
        GoRoute(
          name: Routes.home,
          path: '/',
          redirect: (_, state) => '/${Routes.taskList}',
          builder: (_, state) => const Center(
            child: Text('Hello there...'),
          ),
        ),
        ShellRoute(
          builder: (_, state, child) {
            return CustomBanner(text: bannerText, child: child);
          },
          routes: [
            TaskListRoute(
              name: Routes.taskList,
              path: '/${Routes.taskList}',
              taskListArguments: taskListDI.taskListArguments,
              routes: [
                TaskInfoRoute(
                  name: Routes.task,
                  path: ':id',
                  taskInfoArguments: taskListDI.taskInfoArguments,
                  routes: [],
                ).getRoute(),
              ],
            ).getRoute()
          ],
        ),
      ],
    );
  }
}
