part of 'task_list_bloc.dart';

abstract class TaskListEvent extends Equatable {
  const TaskListEvent();
}

class LoadTaskList extends TaskListEvent {
  @override
  List<Object?> get props => [];
}

class SaveTaskList extends TaskListEvent {
  @override
  List<Object?> get props => [];
}

class TaskAdd extends TaskListEvent {
  final TaskModel task;
  const TaskAdd(this.task);

  @override
  List<Object?> get props => [task];
}

class TaskUpdate extends TaskListEvent {
  final TaskModel task;
  const TaskUpdate(this.task);

  @override
  List<Object?> get props => [task];
}

class TaskDelete extends TaskListEvent {
  final TaskModel task;
  const TaskDelete(this.task);

  @override
  List<Object?> get props => [task];
}

class ToggleTask extends TaskListEvent {
  final TaskModel task;
  const ToggleTask(this.task);

  @override
  List<Object?> get props => [task];
}
