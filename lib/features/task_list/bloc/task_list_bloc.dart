import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplify_the_task/models/task_model.dart';
import 'package:simplify_the_task/repositories/task_repository.dart';

part 'task_list_event.dart';
part 'task_list_state.dart';

class TaskListBloc extends Bloc<TaskListEvent, TaskListState> {
  final TaskRepository _taskRepository = TaskRepository();

  TaskListBloc() : super(TaskListInitial()) {
    on<LoadTaskList>(_onLoadTaskList);
    on<SaveTaskList>(_onSaveTaskList);
    on<TaskAdd>(_onTaskAdd);
    on<TaskUpdate>(_onTaskUpdate);
    on<TaskDelete>(_onTaskDelete);
    on<ToggleTask>(_onTaskToggle);
  }

  void _onLoadTaskList(LoadTaskList event, Emitter<TaskListState> emit) async {
    final List<TaskModel> taskList = await _taskRepository.getTaskList();
    emit(TaskListLoaded(taskList: taskList));
  }

  void _onTaskAdd(TaskAdd event, Emitter<TaskListState> emit) async {
    emit(TaskListLoaded(taskList: List.from(state.taskList)..add(event.task)));
  }

  void _onTaskDelete(TaskDelete event, Emitter<TaskListState> emit) {
    emit(
      TaskListLoaded(taskList: List.from(state.taskList)..remove(event.task)),
    );
  }

  void _onTaskToggle(ToggleTask event, Emitter<TaskListState> emit) {
    final int index = state.taskList.indexOf(event.task);
    final TaskModel newTask = TaskModel(
        id: event.task.id,
        description: event.task.description,
        completed: !event.task.completed,
        deadline: event.task.deadline,
        priority: event.task.priority);
    emit(TaskListLoaded(
        taskList: List.from(state.taskList)
          ..removeAt(index)
          ..insert(index, newTask)));
  }

  void _onTaskUpdate(TaskUpdate event, Emitter<TaskListState> emit) {
    final int index =
        state.taskList.indexWhere((task) => task.id == event.task.id);
    emit(TaskListLoaded(
        taskList: List.from(state.taskList)
          ..removeAt(index)
          ..insert(index, event.task)));
  }

  FutureOr<void> _onSaveTaskList(
      SaveTaskList event, Emitter<TaskListState> emit) async {
    _taskRepository.saveAllTasksToStorage(state.taskList);
  }
}
