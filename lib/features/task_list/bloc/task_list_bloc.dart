import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:simplify_the_task/features/task_list/repositories/task_list_repository.dart';
import 'package:simplify_the_task/models/task_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_list_bloc.freezed.dart';

part 'task_list_event.dart';
part 'task_list_state.dart';

class TaskListBloc extends Bloc<TaskListEvent, TaskListState> {
  final TaskListRepository _taskListRepository = TaskListRepository();

  final Logger logger = Logger();

  TaskListBloc() : super(const TaskListState.initial()) {
    on<TaskListLoad>(_onTaskListLoad);
    on<TaskListSave>(_onTaskListSave);
    on<TaskListAdd>(_onTaskListAdd);
    on<TaskListUpdate>(_onTaskListUpdate);
    on<TaskListDelete>(_onTaskListDelete);
    on<TaskListToggle>(_onTaskListToggle);
    on<TaskListSynch>(_onTaskListSynch);
  }

  // _loadTaskListFromYandexRepository() {
  //   _yandexRepository.getTaskList().then((value) {
  //     logger.i('Task List from yandex: $value');
  //   });
  // }

  void _onTaskListLoad(TaskListLoad event, Emitter<TaskListState> emit) async {
    emit(const TaskListState.loading());
    // _loadTaskListFromYandexRepository();
    final List<TaskModel> taskList = await _taskListRepository.getTaskList();
    emit(TaskListState.loaded(taskList: taskList));
  }

  void _onTaskListAdd(TaskListAdd event, Emitter<TaskListState> emit) async {
    if (state is _TaskListLoaded) {
      // _taskLoading(emit);
      _taskListRepository.saveTask(event.task);
      final stateLoaded = state as _TaskListLoaded;
      emit(TaskListState.loaded(
        taskList: List.from(stateLoaded.taskList)..insert(0, event.task),
      ));
    }
  }

  void _onTaskListUpdate(TaskListUpdate event, Emitter<TaskListState> emit) {
    if (state is _TaskListLoaded) {
      _taskListRepository.saveTask(event.task);
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
      // final stateLoaded = state as _TaskListLoaded;
      // _taskListRepository.saveTaskList(stateLoaded.taskList);
    }
  }

  void _onTaskListDelete(TaskListDelete event, Emitter<TaskListState> emit) {
    if (state is _TaskListLoaded) {
      // _taskLoading(emit);
      _taskListRepository.deleteTask(event.task);
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
      _taskListRepository.saveTask(newTask);
      emit(
        TaskListState.loaded(
          taskList: List.from(stateLoaded.taskList)
            ..removeAt(index)
            ..insert(index, newTask),
        ),
      );
    }
  }

  void _onTaskListSynch(
      TaskListSynch event, Emitter<TaskListState> emit) async {
    emit(const TaskListState.loading());
    List<TaskModel> taskList = await _taskListRepository.syncRepositories();
    emit(TaskListState.loaded(taskList: taskList));
  }
}
