import 'dart:io';

import 'package:isar/isar.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simplify_the_task/models/task_model_isar.dart';

class IsarRepository {
  late Future<Directory> appDirectory;
  Isar? _isar;
  final Logger logger = Logger();

  String directoryName;

  Future<Directory> get _appDir async {
    final documentsPath = await getApplicationDocumentsDirectory();
    return Directory('${documentsPath.path}/$directoryName')
        .create(recursive: true);
  }

  Future<Isar> get isarInstance async {
    final appDir = await _appDir;
    _isar ??= await Isar.open(
      [TaskModelIsarSchema],
      directory: appDir.path,
      inspector: true,
    );
    return _isar!;
  }

  IsarRepository({required this.directoryName});

  Future<List<TaskModelIsar>> getTaskList() {
    return isarInstance
        .then((Isar isar) => isar.taskModelIsars.where().findAll());
  }

  Future<void> updateTask(TaskModelIsar task) async {
    final isar = await isarInstance;
    final taskToDelete = await isar.taskModelIsars
        .filter()
        .taskIdEqualTo(task.taskId)
        .findFirst();
    if (taskToDelete != null) {
      await _delete(taskToDelete.id);
    }
    isar.writeTxn(() => isar.taskModelIsars.put(task));
  }

  Future<void> deleteTask(String taskId) async {
    final isar = await isarInstance;
    isar.writeTxn(
      () => isar.taskModelIsars.filter().taskIdEqualTo(taskId).deleteAll(),
    );
  }

  Future<void> _delete(int id) async {
    final isar = await isarInstance;
    await isar.writeTxn(() => isar.taskModelIsars.delete(id));
  }
}
