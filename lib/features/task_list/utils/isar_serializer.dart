import 'package:simplify_the_task/models/task_model.dart';
import 'package:simplify_the_task/models/task_model_isar.dart';
import 'package:uuid/uuid.dart';

class IsarSerializer {
  static TaskModelIsar taskModelToTaskModelIsar(TaskModel task) {
    return TaskModelIsar()
      ..taskId = task.id
      ..text = task.text
      ..completed = task.completed
      ..deadline = task.deadline
      ..priority = task.priority;
  }

  static TaskModel taskModelIsarToTaskModel(TaskModelIsar task) {
    return TaskModel(
      id: task.taskId ?? const Uuid().v4(),
      text: task.text ?? '',
      completed: task.completed ?? false,
      deadline: task.deadline,
      priority: task.priority,
    );
  }
}
