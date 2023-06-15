part of 'task_list_bloc.dart';

@freezed
class TaskListEvent with _$TaskListEvent {
  const factory TaskListEvent.load() = TaskListLoad;
  const factory TaskListEvent.save() = TaskListSave;
<<<<<<< HEAD
  const factory TaskListEvent.synch() = TaskListSynch;
  const factory TaskListEvent.close() = TaskListClose;
=======
>>>>>>> d5b4746 (equitable => freezed)
  const factory TaskListEvent.add({
    required TaskModel task,
  }) = TaskListAdd;
  const factory TaskListEvent.update({
    required TaskModel task,
  }) = TaskListUpdate;
  const factory TaskListEvent.delete({
    required TaskModel task,
  }) = TaskListDelete;
  const factory TaskListEvent.toggle({
    required TaskModel task,
  }) = TaskListToggle;
}
