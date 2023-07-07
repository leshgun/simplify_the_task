import 'dart:io';

import 'package:isar/isar.dart';
import 'package:logger/logger.dart';
import 'package:simplify_the_task/data/api/isar_api.dart';
import 'package:simplify_the_task/data/models/isar/task_model_isar.dart';

class IsarRepository {
  final Logger logger = Logger();
  Isar? _isar;
  Directory? _directory;
  IsarApi isarApi;

  IsarRepository({required this.isarApi}) : _isar = isarApi.isar;

  Future<Isar> get isarInstance async {
    if (_isar != null) {
      return _isar!;
    }
    final instance = Isar.getInstance('TaskList');
    if (instance != null) {
      _isar = instance;
      return _isar!;
    }
    _directory ??= await isarApi.directory;
    _isar = await Isar.open(
      [TaskModelIsarSchema],
      directory: _directory?.path ?? '',
      inspector: true,
      name: 'TaskList',
    );
    return _isar!;
  }

  Future<List<TaskModelIsar>> getTaskList() {
    return isarInstance.then((Isar isar) =>
        isar.taskModelIsars.where(sort: Sort.desc).anyId().findAll());
  }

  Future<void> updateTaskList(List<TaskModelIsar> taskList) async {
    for (TaskModelIsar task in taskList) {
      await updateTask(task);
    }
  }

  Future<void> updateTask(TaskModelIsar task) async {
    final isar = await isarInstance;
    final taskInDB = await isar.taskModelIsars
        .filter()
        .taskIdEqualTo(task.taskId)
        .findFirst();
    if (taskInDB != null) {
      task = task..id = taskInDB.id;
    }
    isar.writeTxn(() => isar.taskModelIsars.put(task));
  }

  Future<void> deleteTask(String taskId) async {
    final isar = await isarInstance;
    isar.writeTxn(
      () => isar.taskModelIsars.filter().taskIdEqualTo(taskId).deleteAll(),
    );
  }

  // ignore: unused_element
  Future<void> _delete(int id) async {
    final isar = await isarInstance;
    await isar.writeTxn(() => isar.taskModelIsars.delete(id));
  }
}
