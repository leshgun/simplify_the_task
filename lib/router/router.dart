import 'package:simplify_the_task/features/task/task.dart';
import 'package:simplify_the_task/features/task_list/task_list.dart';

final routes = {
  '/task-list': (context) => const TaskList(),
  '/task-details': (context) => const Task(),
};
