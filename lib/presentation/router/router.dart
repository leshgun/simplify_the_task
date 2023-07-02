import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
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
      path: '/task-list',
      builder: (context, state) => const TaskListScreen(),
    ),
    GoRoute(
      path: '/task-info',
      builder: (context, state) {
        final args = state.extra;
        if (args is! TaskInfoArguments) {
          Logger().w('Wrong arguments for screen "task-info"');
          return context.widget;
        }
        return TaskInfoScreen(arguments: args);
      },
    ),
  ],
);
