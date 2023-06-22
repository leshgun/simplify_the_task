import 'package:simplify_the_task/models/task_model.dart';
import 'package:simplify_the_task/models/task_model_isar.dart';
import 'package:simplify_the_task/models/task_model_yandex.dart';
import 'package:uuid/uuid.dart';

class YandexSerializer {
  static final List<String> importance = ['basic', 'low', 'important'];

  static TaskModelYandex fromTaskModel(TaskModel task) {
    return TaskModelYandex(
      id: task.id.toString(),
      text: task.text,
      deadline:
          task.deadline == null ? null : dateTimeToTimestamp(task.deadline!),
      importance: importance[task.priority ?? 0],
      done: task.completed,
      createdAt: dateTimeToTimestamp(task.createdAt),
      changedAt: dateTimeToTimestamp(task.changedAt),
      lastUpdatedBy: '0', // TODO: code review
    );
  }

  static TaskModel toTaskModel(TaskModelYandex task) {
    return TaskModel(
      id: task.id,
      text: task.text,
      deadline:
          task.deadline == null ? null : timestampToDateTime(task.deadline!),
      completed: task.done,
      priority: importance.indexOf(task.importance),
      createdAt: timestampToDateTime(task.createdAt),
      changedAt: timestampToDateTime(task.changedAt),
    );
  }

  static TaskModelYandex fromTaskModelIsar(TaskModelIsar task) {
    return TaskModelYandex(
      id: task.taskId ?? const Uuid().v4(),
      text: task.text ?? '',
      importance: importance[task.priority ?? 0],
      done: task.completed ?? false,
      createdAt: dateTimeToTimestamp(task.changedAt ?? DateTime.now()),
      changedAt: dateTimeToTimestamp(task.changedAt ?? DateTime.now()),
      lastUpdatedBy: '0', // TODO: code review
      color: '',
      deadline:
          task.deadline != null ? dateTimeToTimestamp(task.deadline!) : null,
    );
  }

  static int dateTimeToTimestamp(DateTime date) {
    return date.toUtc().millisecondsSinceEpoch;
  }

  static DateTime timestampToDateTime(int timestamp) {
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }
}
