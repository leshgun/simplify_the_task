import 'package:simplify_the_task/data/models/models.dart';
import 'package:simplify_the_task/features/task_list/repositories/task_list_repository.dart';

class TaskListMultiRepository extends TaskListRepository {
  // late final IsarRepository isarRepository;
  // late final YandexRepository yandexRepository;

  List<TaskListRepository> repositoryList;

  TaskListMultiRepository({
    // required this.isarRepository,
    // required this.yandexRepository,
    required this.repositoryList
  });

  @override
  Future<List<TaskModel>> getTaskList() async {
    if (repositoryList.isEmpty) {
      return [];
    }
    final List<TaskModel> list = await repositoryList.first.getTaskList();
    if (repositoryList.length < 2) {
      return list;
    }
    return list;
    // final List<TaskModelIsar> list = await isarRepository.getTaskList();
    // final List<TaskModel> taskList =
    //     list.map((task) => IsarSerializer.toTaskModel(task)).toList();
    // taskList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    // return taskList;
  }

  @override
  Future<void> saveTask(TaskModel task) async {
    if (repositoryList.isEmpty) return;
    repositoryList.first.saveTask(task);
    // isarRepository.updateTask(IsarSerializer.fromTaskModel(task));
  }

  @override
  Future<void> deleteTask(TaskModel task) async {
    if (repositoryList.isEmpty) return;
    repositoryList.first.deleteTask(task);
    // isarRepository.deleteTask(task.id);
  }

  @override
  Future<List<TaskModel>> syncRepositories() async {
    if (repositoryList.isEmpty) return [];
    return repositoryList.first.getTaskList();
    // List<TaskModelIsar> taskListIsar = await isarRepository.getTaskList();
    // List<TaskModelYandex> taskListYandex;
    // List<TaskModel> taskList = [];
    // if (taskListIsar.isEmpty) {
    //   taskListYandex = await yandexRepository.getTaskList();
    // } else {
    //   taskListYandex = await yandexRepository.mergeData(
    //     taskListIsar
    //         .map((TaskModelIsar task) =>
    //             YandexSerializer.fromTaskModelIsar(task))
    //         .toList(),
    //   );
    // }
    // if (taskListYandex.isEmpty) {
    //   taskList = taskListIsar
    //       .map((TaskModelIsar task) => IsarSerializer.toTaskModel(task))
    //       .toList();
    // } else {
    //   taskList = taskListYandex
    //       .map((TaskModelYandex task) => YandexSerializer.toTaskModel(task))
    //       .toList();
    //   isarRepository.updateTaskList(taskListYandex
    //       .map((TaskModelYandex task) =>
    //           IsarSerializer.fromTaskModelYandex(task))
    //       .toList());
    // }
    // taskList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    // return taskList;
  }
  
  @override
  Future<void> closeRepositories() async {
    return;
  }
}
