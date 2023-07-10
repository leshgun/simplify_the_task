// import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simplify_the_task/data/repositories/repositories.dart';
import 'package:simplify_the_task/data/repositories/task_list/task_list_yandex_repository.dart';
import 'package:simplify_the_task/features/task/task_info_screen.dart';
import 'package:simplify_the_task/features/task_list/bloc/task_list_bloc.dart';
import 'package:simplify_the_task/features/task_list/task_list_screen.dart';
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
  late TaskListArguments taskListArguments;
  late TaskInfoArguments taskInfoArguments;

  MyRouter({this.bannerText}) {
    _initDI();
    _initRouter();
  }

  void _initDI() {
    final TaskListYandexRepository yandexRepo = TaskListYandexRepository(
      token: const String.fromEnvironment('yandex_api_key'),
    );
    final TaskListBloc taskListBloc = TaskListBloc(
      taskListRepository: TaskListMultiRepository(repositoryList: []),
    );
    taskListArguments = TaskListArguments(
      taskListBloc: taskListBloc,
    );
    taskInfoArguments = TaskInfoArguments(
      onSaveTask: (task) => taskListBloc.add(TaskListEvent.add(task: task)),
    );
  }

  void _initRouter() {
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
              taskListArguments: taskListArguments,
              routes: [
                TaskInfoRoute(
                  name: Routes.task,
                  path: ':id',
                  taskInfoArguments: taskInfoArguments,
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
