// import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simplify_the_task/features/task/task_info_screen.dart';
import 'package:simplify_the_task/features/task_list/bloc/task_list_bloc.dart';
import 'package:simplify_the_task/features/task_list/repositories/task_list_repository.dart';
import 'package:simplify_the_task/features/task_list/task_list_screen.dart';

class Routes {
  static const home = "home";
  static const task = "task";
  static const taskList = "task-list";
  static const unknown = "unknown";
}

class MyRouter {
  static final TaskListBloc taskListBloc = TaskListBloc(
    taskListRepository: TaskListRepository(),
  );

  static final TaskListArguments taskListArguments = TaskListArguments(
    taskListBloc: taskListBloc,
  );

  static final TaskInfoArguments taskInfoArguments = TaskInfoArguments(
    onSaveTask: (task) => taskListBloc.add(TaskListEvent.add(task: task)),
  );

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
  );
}
