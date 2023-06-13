part of 'task_list_bloc.dart';

abstract class TaskListState extends Equatable {
  final List<TaskModel> taskList;

  const TaskListState({this.taskList = const <TaskModel>[]});

  @override
  List<Object?> get props => [taskList];
}

class TaskListInitial extends TaskListState {
  @override
  List<Object?> get props => [];
}

class TaskListLoaded extends TaskListState {
  const TaskListLoaded({required super.taskList});

  @override
  List<Object?> get props => [super.taskList];
}
