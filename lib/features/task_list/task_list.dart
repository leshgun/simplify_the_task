import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    final pageTheme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          taskListAppBar(pageTheme),
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

  Widget taskListAppBar(ThemeData pageTheme) {
    return BlocBuilder<TaskListBloc, TaskListState>(
      builder: (context, state) {
        int completed = state.taskList.where((task) => task.completed).length;
        return SliverAppBar(
          pinned: true,
          expandedHeight: 150,
          collapsedHeight: 64,
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.pin,
            expandedTitleScale: 1.6,
            background: Container(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 32, bottom: 8),
                child: Text(
                  "Выполнено: $completed",
                  // style: pageTheme.textTheme.,
                  style: pageTheme.textTheme.bodyMedium
                      ?.apply(color: pageTheme.disabledColor),
                ),
              ),
            ),
            titlePadding: const EdgeInsets.only(
              left: 32,
              right: 16,
              bottom: 20,
              top: 16,
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Мои дела", style: pageTheme.textTheme.titleLarge),
                IconButton(
                  onPressed: _toggleShowCompleted,
                  alignment: Alignment.center,
                  hoverColor: Colors.transparent,
                  splashRadius: 24,
                  icon: Icon(
                    isShowCompleted ? Icons.visibility : Icons.visibility_off,
                    color: Colors.blue,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
              final task = taskList[index];
              return TaskTile(task: task);
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
