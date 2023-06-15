import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplify_the_task/features/task_list/widgets/task_list_app_bar.dart';
import 'package:simplify_the_task/features/task_list/widgets/task_tile.dart';
import 'package:simplify_the_task/models/task_model.dart';

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

  @override
  void initState() {
    super.initState();
    _taskListBloc.add(const TaskListLoad());
    timer = Timer.periodic(
      const Duration(seconds: 16),
      (Timer t) => _saveTasksToStorage(),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  _addNewTask() {
    Navigator.of(context).pushNamed(
      '/task-details',
    );
  }

  _toggleShowCompleted() {
    setState(() {
      isShowCompleted = !isShowCompleted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          TaskListAppBar(
            visibility: isShowCompleted,
            callback: _toggleShowCompleted,
          ),
          SliverToBoxAdapter(
            child: _blocBuilder(context),
            // child: BlocBuilder(
            //   bloc: BlocProvider.of<TaskListBloc>(context),
            //   builder: _blocBuilder,
            // ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewTask,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _blocBuilder(BuildContext context) {
    final pageTheme = Theme.of(context);
    final state = context.watch<TaskListBloc>().state;

    return state.when(
      initial: () => const Text('There are no tasks...'),
      loading: () => const CircularProgressIndicator(),
      loaded: (List<TaskModel> taskList) {
        if (!isShowCompleted) {
          taskList = taskList.where((task) => !task.completed).toList();
        }
        if (taskList.isEmpty) {
          return const Icon(Icons.done_all);
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
          ),
        );
      },
    );
  }
}
