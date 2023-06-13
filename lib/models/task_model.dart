import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:simplify_the_task/models/task_entity.dart';

class TaskModel extends TaskEntity {
  const TaskModel(
      {required super.id,
      required super.description,
      super.completed,
      super.priority,
      super.deadline});

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    DateTime? deadline;
    final logger = Logger();
    try {
      deadline = DateTime.parse(json['deadline']);
    } catch (e) {
      logger.w(e);
    }
    return TaskModel(
      id: json['id'],
      description: json['description'],
      completed: json['completed'] ?? false,
      priority: json['priority'] ?? 0,
      deadline: deadline,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'completed': completed,
      'priority': priority ?? 0,
      'deadline': deadline?.toIso8601String()
    };
  }

  @override
  String toString() {
    // return super.toString();
    return jsonEncode(toJson());
  }
}
