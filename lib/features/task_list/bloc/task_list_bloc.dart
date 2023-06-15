import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplify_the_task/models/task_model.dart';
import 'package:simplify_the_task/repositories/task_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_list_bloc.freezed.dart';

part 'task_list_event.dart';
part 'task_list_state.dart';

class TaskListBloc extends Bloc<TaskListEvent, TaskListState> {
  final TaskRepository _taskRepository = TaskRepository();

  TaskListBloc() : super(const TaskListState.initial()) {
    on<TaskListLoad>(_onTaskListLoad);
    on<TaskListSave>(_onTaskListSave);
    on<TaskListAdd>(_onTaskListAdd);
    on<TaskListUpdate>(_onTaskListUpdate);
    on<TaskListDelete>(_onTaskListDelete);
    on<TaskListToggle>(_onTaskListToggle);
  }

  void _taskLoading(Emitter<TaskListState> emit) {
    emit(const TaskListState.loading());
  }

  void _onTaskListLoad(TaskListLoad event, Emitter<TaskListState> emit) async {
    _taskLoading(emit);
    final List<TaskModel> taskList = await _taskRepository.getTaskList();
    emit(TaskListState.loaded(taskList: taskList));
  }

  void _onTaskListAdd(TaskListAdd event, Emitter<TaskListState> emit) async {
    if (state is _TaskListLoaded) {
      // _taskLoading(emit);
      final stateLoaded = state as _TaskListLoaded;
      emit(TaskListState.loaded(
          taskList: List.from(stateLoaded.taskList)..add(event.task)));
    }
  }

  void _onTaskListUpdate(TaskListUpdate event, Emitter<TaskListState> emit) {
    if (state is _TaskListLoaded) {
      final stateLoaded = state as _TaskListLoaded;
      final int index =
          stateLoaded.taskList.indexWhere((task) => task.id == event.task.id);
      emit(
        TaskListState.loaded(
          taskList: List.from(stateLoaded.taskList)
            ..removeAt(index)
            ..insert(index, event.task),
        ),
      );
    }
  }

  FutureOr<void> _onTaskListSave(
    TaskListSave event,
    Emitter<TaskListState> emit,
  ) async {
    if (state is _TaskListLoaded) {
      final stateLoaded = state as _TaskListLoaded;
      _taskRepository.saveAllTasksToStorage(stateLoaded.taskList);
    }
  }

  void _onTaskListDelete(TaskListDelete event, Emitter<TaskListState> emit) {
    if (state is _TaskListLoaded) {
      // _taskLoading(emit);
      final stateLoaded = state as _TaskListLoaded;
      emit(
        TaskListState.loaded(
          taskList: List.from(stateLoaded.taskList)..remove(event.task),
        ),
      );
    }
  }

  void _onTaskListToggle(TaskListToggle event, Emitter<TaskListState> emit) {
    if (state is _TaskListLoaded) {
      final stateLoaded = state as _TaskListLoaded;
      final int index = stateLoaded.taskList.indexOf(event.task);
      final TaskModel newTask = event.task.copyWith(
        completed: !event.task.completed,
      );
      emit(
        TaskListState.loaded(
          taskList: List.from(stateLoaded.taskList)
            ..removeAt(index)
            ..insert(index, newTask),
        ),
      );
    }
  }
}
