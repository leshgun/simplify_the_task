import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:simplify_the_task/features/task_list/repositories/task_list_repository.dart';
import 'package:simplify_the_task/data/models/task/task_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_list_bloc.freezed.dart';

part 'task_list_event.dart';
part 'task_list_state.dart';

class TaskListBloc extends Bloc<TaskListEvent, TaskListState> {
  final TaskListRepository taskListRepository;

  final Logger logger = Logger();

  TaskListBloc({required this.taskListRepository})
      : super(const TaskListState.initial()) {
    on<TaskListLoad>(_onTaskListLoad);
    on<TaskListSave>(_onTaskListSave);
    on<TaskListAdd>(_onTaskListAdd);
    on<TaskListUpdate>(_onTaskListUpdate);
    on<TaskListDelete>(_onTaskListDelete);
    on<TaskListToggle>(_onTaskListToggle);
    on<TaskListSynch>(_onTaskListSynch);
    on<TaskListClose>(_onTaskListClose);
  }

  void _onTaskListLoad(TaskListLoad event, Emitter<TaskListState> emit) async {
    emit(const TaskListState.loading());
    final List<TaskModel> taskList = await taskListRepository.getTaskList();
    emit(TaskListState.loaded(taskList: taskList));
  }

  void _onTaskListAdd(TaskListAdd event, Emitter<TaskListState> emit) async {
    if (state is _TaskListLoaded) {
      taskListRepository.saveTask(event.task);
      final stateLoaded = state as _TaskListLoaded;
      emit(TaskListState.loaded(
        taskList: List.from(stateLoaded.taskList)..insert(0, event.task),
      ));
    }
  }

  void _onTaskListUpdate(TaskListUpdate event, Emitter<TaskListState> emit) {
    if (state is _TaskListLoaded) {
      taskListRepository.saveTask(event.task);
      final stateLoaded = state as _TaskListLoaded;
      final int index =
          stateLoaded.taskList.indexWhere((task) => task.id == event.task.id);
      emit(
        TaskListState.loaded(
          taskList: List.from(stateLoaded.taskList)
            ..replaceRange(index, index + 1, [event.task]),
        ),
      );
    }
  }

  FutureOr<void> _onTaskListSave(
    TaskListSave event,
    Emitter<TaskListState> emit,
  ) async {
    /// Deprecated ///
    // if (state is _TaskListLoaded) {
    //   final stateLoaded = state as _TaskListLoaded;
    //   taskListRepository.saveTaskList(stateLoaded.taskList);
    // }
  }

  void _onTaskListDelete(TaskListDelete event, Emitter<TaskListState> emit) {
    if (state is _TaskListLoaded) {
      taskListRepository.deleteTask(event.task);
      final stateLoaded = state as _TaskListLoaded;
      emit(
        TaskListState.loaded(
          taskList: List.from(stateLoaded.taskList)
            ..removeWhere((task) => event.task.id == task.id),
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
        changedAt: DateTime.now(),
      );
      taskListRepository.saveTask(newTask);
      emit(
        TaskListState.loaded(
          taskList: List.from(stateLoaded.taskList)
            ..replaceRange(index, index + 1, [newTask]),
        ),
      );
    }
  }

  void _onTaskListSynch(
      TaskListSynch event, Emitter<TaskListState> emit) async {
    emit(const TaskListState.loading());
    List<TaskModel> taskList = await taskListRepository.syncRepositories();
    emit(TaskListState.loaded(taskList: taskList));
  }

  Future<void> _onTaskListClose(
    TaskListClose event,
    Emitter<TaskListState> emit,
  ) async {
    await taskListRepository.closeRepositories();
    emit(const TaskListState.initial());
  }
}
