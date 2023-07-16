import 'package:flutter/material.dart';
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
  final Color? taskPriorityColor;

  const TaskInfoArguments({
    this.onSaveTask,
    this.onUpdateTask,
    this.onDeleteTask,
    this.inputTask,
    this.taskPriorityColor,
  });

  TaskInfoArguments copyWith({
    TaskModel? inputTask,
    Color? taskPriorityColor,
  }) {
    return TaskInfoArguments(
      onSaveTask: onSaveTask,
      onUpdateTask: onUpdateTask,
      onDeleteTask: onDeleteTask,
      inputTask: inputTask ?? this.inputTask,
      taskPriorityColor: taskPriorityColor ?? this.taskPriorityColor,
    );
  }
}
