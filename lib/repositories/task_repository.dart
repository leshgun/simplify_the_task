import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:simplify_the_task/models/task_model.dart';

class TaskRepository {
  final Future<Directory> documetsDir = getApplicationDocumentsDirectory();
  late Future<Directory> appDirectory = createAppDirectory();
  List<TaskModel> _cachedTaskList = [];

  final String _taskListFileName = 'task-list.json';

  TaskRepository() {
    createAppDirectory();
  }

  Future<List<TaskModel>> getTaskList() {
    return appDirectory.then((Directory directory) {
      String path = '${directory.path}/$_taskListFileName';
      if (!File(path).existsSync()) {
        return [];
      }
      return File(path).readAsString().then((String json) {
        if (json.isEmpty) {
          return [];
        }
        final decoded = jsonDecode(json);
        if (decoded is! List<dynamic>) {
          return [];
        }
        for (Map<String, dynamic> task in decoded) {
          _cachedTaskList.add(TaskModel.fromJson(task));
        }
        return _cachedTaskList;
      });
    });
  }

  void saveAllTasksToStorage(List<TaskModel> taskList) async {
    if (taskList == _cachedTaskList) {
      return;
    }
    _cachedTaskList = taskList;
    final String data = taskList.map((t) => t.toString()).toList().toString();
    appDirectory.then((Directory directory) {
      String path = '${directory.path}/$_taskListFileName';
      File(path).create().then((File file) {
        file.writeAsString(data);
      });
    });
  }

  Future<Directory> createAppDirectory() async {
    return documetsDir.then((Directory directory) =>
        Directory('${directory.path}/simplify_the_task')
            .create(recursive: true));
  }
}
