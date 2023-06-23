import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplify_the_task/features/task/task_info_screen.dart';
import 'package:simplify_the_task/features/task_list/widgets/task_list_app_bar.dart';
import 'package:simplify_the_task/features/task_list/widgets/task_tile.dart';
import 'package:simplify_the_task/models/task_model.dart';
import 'package:flutter_gen/gen_l10n/S.dart';

import 'bloc/task_list_bloc.dart';

class TaskList extends StatefulWidget {
  const TaskList({super.key});

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  TaskListBloc get _taskListBloc => BlocProvider.of<TaskListBloc>(context);
  bool isShowCompleted = true;
  List<TaskModel> taskList = [];
  Timer? timer;

  @override
  void initState() {
    _taskListBloc.add(const TaskListLoad());
    _taskListBloc.add(const TaskListSynch());
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  _addNewTask() {
    Navigator.of(context).pushNamed('/task-info',
        arguments: TaskInfoArguments(
          onSaveTask: (task) =>
              _taskListBloc.add(TaskListEvent.add(task: task)),
        ));
  }

  _syncTaskList() {
    _taskListBloc.add(const TaskListSynch());
  }

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
      ),
      floatingActionButton: FloatingActionButton(
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
      initial: () => Text(S.of(context)!.taskListEmpty),
      loading: () => const Padding(
        padding: EdgeInsets.only(top: 32),
        child: Center(
          child: CircularProgressIndicator(color: Colors.blue),
        ),
      ),
      loaded: (List<TaskModel> taskList) {
        if (!isShowCompleted) {
          taskList = taskList.where((task) => !task.completed).toList();
        }
        if (taskList.isEmpty) {
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
                    return TaskTile(task: taskList[index]);
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
                  onTap: () {
                    _addNewTask();
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
