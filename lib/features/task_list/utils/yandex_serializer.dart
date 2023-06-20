import 'package:simplify_the_task/models/task_model.dart';
import 'package:simplify_the_task/models/task_model_yandex.dart';

class YandexSerializer {
  static final List<String> importance = ['low', 'basic', 'important'];

  static TaskModelYandex taskModelToTaskModelYandex(TaskModel task) {
    return TaskModelYandex(
      id: task.id.toString(),
      text: task.text,
      deadline: dateTimeToTimestamp(task.deadline),
      importance: importance[task.priority ?? 0],
      done: task.completed,
      createdAt: dateTimeToTimestamp(DateTime.now())!,
      changedAt: dateTimeToTimestamp(DateTime.now())!,
      lastUpdatedBy: '',
    );
  }

  static int? dateTimeToTimestamp(DateTime? date) {
    if (date == null) {
      return null;
    }
    return date.toUtc().millisecondsSinceEpoch ~/ 1000;
  }
}
