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
  get _taskListBloc => BlocProvider.of<TaskListBloc>(context);
  bool isShowCompleted = true;
  List<TaskModel> taskList = [];
  Timer? timer;

  void _saveTasksToStorage() async {
    if (_taskListBloc.state.taskList.isEmpty) {
      return;
    }
    _taskListBloc.add(SaveTaskList());
  }

  @override
  void initState() {
    super.initState();
    _taskListBloc.add(LoadTaskList());
    timer = Timer.periodic(
      const Duration(seconds: 16),
      (Timer t) => _saveTasksToStorage(),
    );
  }

  @override
  void didChangeDependencies() {
    _saveTasksToStorage();
    super.didChangeDependencies();
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
            child: BlocBuilder(
              bloc: BlocProvider.of<TaskListBloc>(context),
              builder: _blocBuilder,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewTask,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _blocBuilder(BuildContext context, state) {
    final pageTheme = Theme.of(context);

    if (state is! TaskListLoaded) {
      return Container();
    }
    taskList = state.taskList;
    if (!isShowCompleted) {
      taskList = taskList.where((task) => !task.completed).toList();
    }
    if (taskList.isEmpty) {
      return Container();
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
  }
}
