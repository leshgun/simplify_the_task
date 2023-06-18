import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
<<<<<<< HEAD
<<<<<<< HEAD
import 'package:logger/logger.dart';
import 'package:simplify_the_task/features/task_list/repositories/task_list_repository.dart';
import 'package:simplify_the_task/data/models/task/task_model.dart';
=======
import 'package:simplify_the_task/models/task_model.dart';
import 'package:simplify_the_task/repositories/task_repository.dart';
>>>>>>> d5b4746 (equitable => freezed)
=======
import 'package:logger/logger.dart';
import 'package:simplify_the_task/features/task_list/repositories/task_list_repository.dart';
import 'package:simplify_the_task/models/task_model.dart';
>>>>>>> 2ab6a09 (code review)
import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_list_bloc.freezed.dart';

part 'task_list_event.dart';
part 'task_list_state.dart';

class TaskListBloc extends Bloc<TaskListEvent, TaskListState> {
<<<<<<< HEAD
  final TaskListRepository taskListRepository;
=======
  final TaskListRepository _taskListRepository = TaskListRepository();
  
  final Logger logger = Logger();
>>>>>>> 2ab6a09 (code review)

<<<<<<< HEAD
  final Logger logger = Logger();

  TaskListBloc({required this.taskListRepository})
      : super(const TaskListState.initial()) {
=======
  TaskListBloc() : super(const TaskListState.initial()) {
>>>>>>> d5b4746 (equitable => freezed)
    on<TaskListLoad>(_onTaskListLoad);
    on<TaskListSave>(_onTaskListSave);
    on<TaskListAdd>(_onTaskListAdd);
    on<TaskListUpdate>(_onTaskListUpdate);
    on<TaskListDelete>(_onTaskListDelete);
    on<TaskListToggle>(_onTaskListToggle);
<<<<<<< HEAD
    on<TaskListSynch>(_onTaskListSynch);
    on<TaskListClose>(_onTaskListClose);
  }

  void _onTaskListLoad(TaskListLoad event, Emitter<TaskListState> emit) async {
    emit(const TaskListState.loading());
    final List<TaskModel> taskList = await taskListRepository.getTaskList();
=======
  }

  // _loadTaskListFromYandexRepository() {
  //   _yandexRepository.getTaskList().then((value) {
  //     logger.i('Task List from yandex: $value');
  //   });
  // }

  void _onTaskListLoad(TaskListLoad event, Emitter<TaskListState> emit) async {
<<<<<<< HEAD
    _taskLoading(emit);
    final List<TaskModel> taskList = await _taskRepository.getTaskList();
>>>>>>> d5b4746 (equitable => freezed)
=======
    emit(const TaskListState.loading());
    // _loadTaskListFromYandexRepository();
    final List<TaskModel> taskList = await _taskListRepository.getTaskList();
>>>>>>> 2ab6a09 (code review)
    emit(TaskListState.loaded(taskList: taskList));
  }

  void _onTaskListAdd(TaskListAdd event, Emitter<TaskListState> emit) async {
    if (state is _TaskListLoaded) {
<<<<<<< HEAD
      taskListRepository.saveTask(event.task);
      final stateLoaded = state as _TaskListLoaded;
      emit(TaskListState.loaded(
        taskList: List.from(stateLoaded.taskList)..insert(0, event.task),
      ));
=======
      // _taskLoading(emit);
      _taskListRepository.saveTask(event.task);
      final stateLoaded = state as _TaskListLoaded;
      emit(TaskListState.loaded(
          taskList: List.from(stateLoaded.taskList)..add(event.task)));
>>>>>>> d5b4746 (equitable => freezed)
    }
  }

  void _onTaskListUpdate(TaskListUpdate event, Emitter<TaskListState> emit) {
    if (state is _TaskListLoaded) {
<<<<<<< HEAD
      taskListRepository.saveTask(event.task);
=======
>>>>>>> d5b4746 (equitable => freezed)
      final stateLoaded = state as _TaskListLoaded;
      final int index =
          stateLoaded.taskList.indexWhere((task) => task.id == event.task.id);
      emit(
        TaskListState.loaded(
          taskList: List.from(stateLoaded.taskList)
<<<<<<< HEAD
            ..replaceRange(index, index + 1, [event.task]),
=======
            ..removeAt(index)
            ..insert(index, event.task),
>>>>>>> d5b4746 (equitable => freezed)
        ),
      );
    }
  }

  FutureOr<void> _onTaskListSave(
    TaskListSave event,
    Emitter<TaskListState> emit,
  ) async {
<<<<<<< HEAD
    /// Deprecated ///
    // if (state is _TaskListLoaded) {
    //   final stateLoaded = state as _TaskListLoaded;
    //   taskListRepository.saveTaskList(stateLoaded.taskList);
    // }
=======
    if (state is _TaskListLoaded) {
      final stateLoaded = state as _TaskListLoaded;
      _taskListRepository.saveTaskList(stateLoaded.taskList);
    }
>>>>>>> d5b4746 (equitable => freezed)
  }

  void _onTaskListDelete(TaskListDelete event, Emitter<TaskListState> emit) {
    if (state is _TaskListLoaded) {
<<<<<<< HEAD
      taskListRepository.deleteTask(event.task);
      final stateLoaded = state as _TaskListLoaded;
      emit(
        TaskListState.loaded(
          taskList: List.from(stateLoaded.taskList)
            ..removeWhere((task) => event.task.id == task.id),
=======
      // _taskLoading(emit);
      final stateLoaded = state as _TaskListLoaded;
      emit(
        TaskListState.loaded(
          taskList: List.from(stateLoaded.taskList)..remove(event.task),
>>>>>>> d5b4746 (equitable => freezed)
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
<<<<<<< HEAD
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
=======
      emit(
        TaskListState.loaded(
          taskList: List.from(stateLoaded.taskList)
            ..removeAt(index)
            ..insert(index, newTask),
        ),
      );
    }
>>>>>>> d5b4746 (equitable => freezed)
  }
}
