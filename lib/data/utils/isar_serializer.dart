import 'package:simplify_the_task/data/utils/yandex_serializer.dart';
import 'package:simplify_the_task/data/models/models.dart';
import 'package:uuid/uuid.dart';

class IsarSerializer {
  static TaskModelIsar fromJson(Map<String, dynamic> json) {
    return TaskModelIsar()
      ..taskId = json['id']
      ..text = json['text']
      ..completed = json['completed']
      ..deadline = json['deadline']
      ..priority = json['priority']
      ..createdAt = json['createdAt']
      ..changedAt = json['changedAt'];
  }

  static TaskModelIsar fromTaskModel(TaskModel task) {
    return TaskModelIsar()
      ..taskId = task.id
      ..text = task.text
      ..completed = task.completed
      ..deadline = task.deadline
      ..priority = task.priority
      ..createdAt = task.createdAt
      ..changedAt = task.changedAt;
  }

  static TaskModelIsar fromTaskModelYandex(TaskModelYandex task) {
    return TaskModelIsar()
      ..taskId = task.id
      ..text = task.text
      ..completed = task.done
      ..deadline = task.deadline == null
          ? null
          : YandexSerializer.timestampToDateTime(task.deadline!)
      ..priority =
          YandexSerializer.importance.indexWhere((i) => i == task.importance)
      ..createdAt = YandexSerializer.timestampToDateTime(task.createdAt)
      ..changedAt = YandexSerializer.timestampToDateTime(task.changedAt);
  }

  static TaskModel toTaskModel(TaskModelIsar task) {
    return TaskModel(
      id: task.taskId ?? const Uuid().v4(),
      text: task.text ?? '',
      completed: task.completed ?? false,
      deadline: task.deadline,
      priority: task.priority,
      createdAt: task.createdAt ?? DateTime.now(),
      changedAt: task.changedAt ?? DateTime.now(),
    );
  }
}
