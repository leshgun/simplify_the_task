part of 'task_list_bloc.dart';

@freezed
class TaskListState with _$TaskListState {
  const factory TaskListState.initial() = _TaskListInitial;
  const factory TaskListState.loading() = _TaskListLoading;
  const factory TaskListState.loaded({
    required List<TaskModel> taskList,
  }) = _TaskListLoaded;
}
