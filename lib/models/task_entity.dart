import 'package:equatable/equatable.dart';

class TaskEntity extends Equatable {
  
  final int id;
  final bool completed;
  final String description;
  final int? priority;
  final DateTime? deadline;

  const TaskEntity({
    required this.id,
    required this.description,
    this.completed = false,
    this.priority,
    this.deadline
    });
  
  @override
  List<Object?> get props => [id, description, completed, priority, deadline];
}
