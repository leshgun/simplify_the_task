import 'package:simplify_the_task/data/repositories/task_list/task_list_isar_repository.dart';
import 'package:simplify_the_task/data/repositories/task_list/task_list_multi_repository.dart';
import 'package:simplify_the_task/data/repositories/task_list/task_list_yandex_repository.dart';
import 'package:simplify_the_task/features/task_info/task_info_screen.dart';
import 'package:simplify_the_task/features/task_list/task_list_screen.dart';

import 'di.dart';

class TaskListDI {
  TaskListDI();

  TaskListYandexRepository? _taskListYandexRepository;
  TaskListIsarRepository? _taskListIsarRepository;
  TaskListMultiRepository? _taskListMultiRepository;
  TaskListBloc? _taskListBloc;
  TaskListArguments? _taskListArguments;
  TaskInfoArguments? _taskInfoArguments;

  TaskListYandexRepository get taskListYandexRepository {
    _taskListYandexRepository ??= TaskListYandexRepository(
      token: const String.fromEnvironment('yandex_api_key'),
    );
    return _taskListYandexRepository!;
  }

  TaskListIsarRepository get taskListIsarRepository {
    _taskListIsarRepository ??= TaskListIsarRepository();
    return _taskListIsarRepository!;
  }

  TaskListMultiRepository get taskListMultiRepository {
    _taskListMultiRepository ??= TaskListMultiRepository(repositoryList: [
      taskListIsarRepository,
      taskListYandexRepository,
    ]);
    return _taskListMultiRepository!;
  }

  TaskListBloc get taskListBloc {
    _taskListBloc ??= TaskListBloc(
      taskListRepository: taskListMultiRepository,
      firebaseAnalytics: FirebaseDI.analytics,
    );
    return _taskListBloc!;
  }

  TaskListArguments get taskListArguments {
    _taskListArguments ??= TaskListArguments(
      taskListBloc: taskListBloc,
      taskPriorityColor: DI.taskPriorityColor,
    );
    return _taskListArguments!;
  }

  TaskInfoArguments get taskInfoArguments {
    _taskInfoArguments ??= TaskInfoArguments(
      onSaveTask: (task) => taskListBloc.add(
        TaskListEvent.add(task: task),
      ),
      onUpdateTask: (task) => taskListBloc.add(
        TaskListEvent.update(task: task),
      ),
      onDeleteTask: (task) => taskListBloc.add(
        TaskListEvent.delete(task: task),
      ),
      taskPriorityColor: DI.taskPriorityColor,
    );
    return _taskInfoArguments!;
  }
}
