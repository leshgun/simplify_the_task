import 'package:simplify_the_task/models/task_model.dart';

class YandexSerializer {
  static final List<String> importance = ['low', 'basic', 'important'];

  static Map<String, dynamic> taskJsonToYandexJson(TaskModel task) {
    return {
      'id': task.id,
      'text': task.text,
      'importance': importance[task.priority ?? 0],
      // 'deadline': dateTimeToTimestamp(task.deadline),
      'done': task.completed,
      // 'color': null,
      'created_at': dateTimeToTimestamp(DateTime.now()),
      'changed_at': dateTimeToTimestamp(DateTime.now()),
      'last_update_by': 1
    };
  }

  static int? dateTimeToTimestamp(DateTime? date) {
    if (date == null) {
      return null;
    }
    return date.toUtc().millisecondsSinceEpoch ~/ 1000;
  }
}
