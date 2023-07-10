import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:simplify_the_task/features/task_list/repositories/task_list_repository.dart';
import 'package:simplify_the_task/features/task_list/repositories/task_list_repository_empty.dart';

import 'bloc/task_list_bloc.dart';
import 'task_list.dart';

class TaskListScreen extends StatelessWidget {
  final TaskListArguments? taskListArguments;

  const TaskListScreen({super.key, this.taskListArguments});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (context) =>
          taskListArguments?.taskListBloc ??
          TaskListBloc(
            taskListRepository: taskListArguments?.taskListRepository ??
                TaskListRepositoryEmpty(),
          ),
      child: const TaskList(),
    );
  }
}

class TaskListArguments {
  final TaskListRepository? taskListRepository;
  final TaskListBloc? taskListBloc;

  const TaskListArguments({this.taskListRepository, this.taskListBloc});
}

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
}
