import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
<<<<<<< HEAD
import 'package:flutter_gen/gen_l10n/S.dart';
import 'package:go_router/go_router.dart';
=======
import 'package:simplify_the_task/features/task/task_info_screen.dart';
import 'package:simplify_the_task/features/task_list/widgets/task_list_app_bar.dart';
import 'package:simplify_the_task/features/task_list/widgets/task_tile.dart';
import 'package:simplify_the_task/models/task_model.dart';
>>>>>>> 07b4506 (code review)

import 'package:simplify_the_task/features/task/task_info_screen.dart';
import 'package:simplify_the_task/data/models/task/task_model.dart';
import 'package:simplify_the_task/presentation/router/router.dart';

import './bloc/task_list_bloc.dart';
import './widgets/task_list_app_bar.dart';
import './widgets/task_tile.dart';

class TaskList extends StatefulWidget {
  const TaskList({super.key});

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  TaskListBloc get _taskListBloc => BlocProvider.of<TaskListBloc>(context);
  bool isShowCompleted = true;
  List<TaskModel> taskList = [];
<<<<<<< HEAD
=======
  Timer? timer;

<<<<<<< HEAD
  void _saveTasksToStorage() async {
    final state = _taskListBloc.state;
    state.when(
      initial: () {},
      loading: () {},
      loaded: (List<TaskModel> taskList) {
        if (taskList.isEmpty) {
          return;
        }
        _taskListBloc.add(const TaskListSave());
      },
    );
  }
>>>>>>> d5b4746 (equitable => freezed)
=======
  // void _saveTasksToStorage() async {
  //   final state = _taskListBloc.state;
  //   state.when(
  //     initial: () {},
  //     loading: () {},
  //     loaded: (List<TaskModel> taskList) {
  //       if (taskList.isEmpty) {
  //         return;
  //       }
  //       _taskListBloc.add(const TaskListSave());
  //     },
  //   );
  // }
>>>>>>> 435c830 (yandex repo)

  @override
  void initState() {
    _taskListBloc.add(const TaskListLoad());
    _taskListBloc.add(const TaskListSynch());
    super.initState();
<<<<<<< HEAD
=======
    _taskListBloc.add(const TaskListLoad());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
>>>>>>> d5b4746 (equitable => freezed)
  }

  _addNewTask() {
<<<<<<< HEAD
    context.goNamed(
      Routes.task,
      pathParameters: {'id': 'new'},
      extra: TaskInfoArguments(
        onSaveTask: (task) => _taskListBloc.add(
          TaskListEvent.add(task: task),
        ),
      ),
=======
    Navigator.of(context).pushNamed(
      '/task-info',
      arguments: TaskInfoArguments(
        onSaveTask: (task) => _taskListBloc.add(TaskListEvent.add(task: task)),
      )
>>>>>>> 07b4506 (code review)
    );
  }

<<<<<<< HEAD
  _syncTaskList() {
    _taskListBloc.add(const TaskListSynch());
  }
=======
  // _syncTaskList() {
  //   _taskListBloc.add(const TaskListSynch());
  // }
>>>>>>> 7c8e3a0 (code review)

  _toggleShowCompleted() {
    setState(() {
      isShowCompleted = !isShowCompleted;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pageTheme = Theme.of(context);
    final state = context.watch<TaskListBloc>().state;
    final int completed = state.when(
      initial: () => 0,
      loading: () => 0,
      loaded: (List<TaskModel> taskList) =>
          taskList.where((TaskModel task) => task.completed).length,
    );
    return Scaffold(
<<<<<<< HEAD
      body: RefreshIndicator(
        onRefresh: () async {
          _syncTaskList();
        },
        child: CustomScrollView(
          slivers: <Widget>[
            TaskListAppBar(
              visibility: isShowCompleted,
              onVisibility: _toggleShowCompleted,
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(left: 32),
                child: Text(
                  "${S.of(context)!.taskListCompleted}: $completed",
                  style: pageTheme.textTheme.bodyMedium
                      ?.apply(color: pageTheme.disabledColor),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: _blocBuilder(context),
            ),
          ],
        ),
=======
      body: CustomScrollView(
        slivers: <Widget>[
          TaskListAppBar(
            visibility: isShowCompleted,
            callback: _toggleShowCompleted,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 32),
              child: Text(
                "Выполнено: $completed",
                // style: pageTheme.textTheme.,
                style: pageTheme.textTheme.bodyMedium
                    ?.apply(color: pageTheme.disabledColor),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _blocBuilder(context),
            // child: BlocBuilder(
            //   bloc: BlocProvider.of<TaskListBloc>(context),
            //   builder: _blocBuilder,
            // ),
          ),
        ],
>>>>>>> d5b4746 (equitable => freezed)
      ),
      floatingActionButton: FloatingActionButton(
        key: const Key('add_task_btn'),
        onPressed: _addNewTask,
        elevation: 0,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _blocBuilder(BuildContext context) {
    final pageTheme = Theme.of(context);
    final state = context.watch<TaskListBloc>().state;

    return state.when(
<<<<<<< HEAD
      initial: () => Text(S.of(context)!.taskListEmpty),
      loading: () => const Padding(
        padding: EdgeInsets.only(top: 32),
        child: Center(
          child: CircularProgressIndicator(color: Colors.blue),
        ),
      ),
=======
      initial: () => const Text('There are no tasks...'),
<<<<<<< HEAD
      loading: () => const CircularProgressIndicator(),
>>>>>>> d5b4746 (equitable => freezed)
=======
      loading: () => const Padding(
        padding: EdgeInsets.all(8),
        child: Center(
          child: CircularProgressIndicator(color: Colors.blue),
        ),
      ),
>>>>>>> 435c830 (yandex repo)
      loaded: (List<TaskModel> taskList) {
        if (!isShowCompleted) {
          taskList = taskList.where((task) => !task.completed).toList();
        }
        if (taskList.isEmpty) {
<<<<<<< HEAD
<<<<<<< HEAD
          return const Center(child: Icon(Icons.done_all));
        }
        return ClipRect(
          clipBehavior: Clip.antiAlias,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: pageTheme.colorScheme.secondary,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            margin: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ListView.builder(
                  padding: EdgeInsets.zero,
                  physics: const ClampingScrollPhysics(),
                  itemCount: taskList.length,
                  shrinkWrap: true,
                  itemBuilder: (_, index) {
                    return TaskTile(
                      task: taskList[index],
                      key: Key(taskList[index].id),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.add,
                    color: Colors.transparent,
                  ),
                  title: Text(
                    S.of(context)!.taskListNewTask,
                    style: pageTheme.textTheme.bodySmall,
                  ),
                  onTap: _addNewTask,
                )
              ],
            ),
=======
          return const Icon(Icons.done_all);
=======
          return const Center(child: Icon(Icons.done_all));
>>>>>>> 435c830 (yandex repo)
        }
        return Container(
          decoration: BoxDecoration(
            color: pageTheme.colorScheme.secondary,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                spreadRadius: 1,
                blurRadius: 2,
                offset: Offset(0, 2),
              ),
            ],
          ),
          margin: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListView.builder(
                physics: const ClampingScrollPhysics(),
                itemCount: taskList.length,
                shrinkWrap: true,
                itemBuilder: (_, index) {
                  return TaskTile(task: taskList[index]);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.add,
                  color: Colors.transparent,
                ),
                title: Text(
                  'Новое',
                  style: pageTheme.textTheme.bodySmall,
                ),
                onTap: () {
                  _addNewTask();
                },
              )
            ],
>>>>>>> d5b4746 (equitable => freezed)
          ),
        );
      },
    );
  }
}
