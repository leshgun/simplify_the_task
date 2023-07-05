import 'package:isar/isar.dart';

part 'task_model_isar.g.dart';

@collection
class TaskModelIsar {
  Id id = Isar.autoIncrement;
  String? taskId;
  String? text;
  bool? completed;
  int? priority;
  DateTime? deadline;
  DateTime? createdAt;
  DateTime? changedAt;

  Map<String, dynamic> toJson() {
    return {
      'id': taskId,
      'text': text,
      'completed': completed,
      'priority': priority,
      'deadline': deadline,
      'created_at': createdAt,
      'changed_at': changedAt,
    };
  }
}
