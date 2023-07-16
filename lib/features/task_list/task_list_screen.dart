import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'repositories/task_list_repository.dart';
import 'repositories/task_list_repository_empty.dart';
import 'bloc/task_list_bloc.dart';
import 'task_list.dart';

export 'bloc/task_list_bloc.dart';

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
      child: TaskList(args: taskListArguments),
    );
  }
}

class TaskListArguments {
  final TaskListRepository? taskListRepository;
  final TaskListBloc? taskListBloc;
  final Color? taskPriorityColor;

  const TaskListArguments({
    this.taskListRepository,
    this.taskListBloc,
    this.taskPriorityColor,
  });
}
