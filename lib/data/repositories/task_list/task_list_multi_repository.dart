import 'package:logger/logger.dart';
import 'package:simplify_the_task/data/models/models.dart';
import 'package:simplify_the_task/features/task_list/repositories/task_list_repository.dart';

class TaskListMultiRepository extends TaskListRepository {
  List<TaskListRepository> repositoryList;

  TaskListMultiRepository({required this.repositoryList});

  @override
  Future<List<TaskModel>> getTaskList() async {
    if (repositoryList.isEmpty) {
      return [];
    }
    final List<TaskModel> list = await repositoryList.first.getTaskList();
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
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
    Logger().v('Task will be deleted from the first repository', task.id);
    // isarRepository.deleteTask(task.id);
  }

  @override
  Future<List<TaskModel>> syncRepositories() async {
    if (repositoryList.isEmpty) return [];

    List<TaskModel> firstList = await repositoryList.first.getTaskList();
    if (repositoryList.length < 2) return firstList;

    for (int i = 1; i < repositoryList.length; i++) {
      firstList = lastList(firstList, await repositoryList[i].getTaskList());
    }

    saveTaskList(firstList);

    firstList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return firstList;
  }

  @override
  Future<void> closeRepositories() async {
    return;
  }

  List<TaskModel> mergeLists(
    List<TaskModel> firstList,
    List<TaskModel> secondList,
  ) {
    final Set ids = firstList.map((task) => task.id).toSet();
    for (TaskModel task in secondList) {
      if (!ids.contains(task.id)) {
        firstList.add(task);
        continue;
      }
      final TaskModel oldTask = firstList.firstWhere((t) => t.id == task.id);
      if (task.changedAt.isAfter(oldTask.changedAt)) {
        firstList.remove(oldTask);
        firstList.add(task);
      }
    }
    return firstList;
  }

  List<TaskModel> lastList(
    List<TaskModel> firstList,
    List<TaskModel> secondList,
  ) {
    final firstMaxDate = getLastChangesDate(firstList);
    if (firstMaxDate == null) return secondList;

    final secondMaxDate = getLastChangesDate(secondList);
    if (secondMaxDate == null) return firstList;

    if (secondMaxDate.isAfter(firstMaxDate)) {
      return secondList;
    }
    return firstList;
  }

  DateTime? getLastChangesDate(List<TaskModel> list) {
    DateTime? maxDate;
    for (TaskModel task in list) {
      maxDate ??= task.changedAt;
      if (task.changedAt.isAfter(maxDate)) {
        maxDate = task.changedAt;
      }
    }
    return maxDate;
  }

  @override
  Future<void> saveTaskList(List<TaskModel> taskList) async {
    for (TaskListRepository repo in repositoryList) {
      repo.saveTaskList(taskList);
    }
  }
}
