import 'dart:convert';
import 'dart:io';

import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simplify_the_task/models/task_model.dart';

class TaskRepository {
  final Future<Directory> documetsDir = getApplicationDocumentsDirectory();
  late Future<Directory> appDirectory = createAppDirectory();
  final String _taskListFileName = 'task-list.json';
  final Logger logger = Logger();
  int _cachedTaskListHash = [].hashCode;

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
        List<TaskModel> response = [];
        if (json.isEmpty) {
          return [];
        }
        try {
          final decoded = jsonDecode(json);
          if (decoded is! List<dynamic>) {
            return [];
          }

          for (Map<String, dynamic> task in decoded) {
            response.add(TaskModel.fromJson(task));
          }
        } catch (e) {
          logger.w('Cant deserialize Json file!');
          logger.w(e);
        }
        return response;
      });
    });
  }

  void saveAllTasksToStorage(List<TaskModel> taskList) async {
    if (taskList.hashCode == _cachedTaskListHash) {
      return;
    }
    _cachedTaskListHash = taskList.hashCode;
    final List<Map<String, dynamic>> data =
        taskList.map((t) => t.toJson()).toList();
    logger.i(data);
    appDirectory.then((Directory directory) {
      String path = '${directory.path}/$_taskListFileName';
      File(path).create().then((File file) {
        file.writeAsString(jsonEncode(data));
      });
    });
  }

  Future<Directory> createAppDirectory() async {
    return documetsDir.then((Directory directory) =>
        Directory('${directory.path}/simplify_the_task')
            .create(recursive: true));
  }
}
