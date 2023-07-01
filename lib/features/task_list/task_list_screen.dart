import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplify_the_task/features/task_list/repositories/task_list_repository.dart';

import 'bloc/task_list_bloc.dart';
import 'task_list.dart';

class TaskListScreen extends StatelessWidget {
  final TaskListRepository? taskListRepository;

  const TaskListScreen({super.key, this.taskListRepository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (context) => TaskListBloc(
        taskListRepository: taskListRepository ?? TaskListRepository(),
      ),
      child: const TaskList(),
    );
    // return const ;
  }
}
