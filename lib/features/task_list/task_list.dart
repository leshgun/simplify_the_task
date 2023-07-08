import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/S.dart';
import 'package:go_router/go_router.dart';

import 'package:simplify_the_task/features/task/task_info_screen.dart';
import 'package:simplify_the_task/data/models/task/task_model.dart';
import 'package:simplify_the_task/presentation/router/router.dart';
import 'package:simplify_the_task/presentation/widgets/wrapper.dart';

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

  IconData get _visibilityIcon {
    if (!isShowCompleted) {
      return Icons.visibility_off;
    }
    return Icons.visibility;
  }

  @override
  void initState() {
    _taskListBloc.add(const TaskListLoad());
    _taskListBloc.add(const TaskListSynch());
    super.initState();
  }

  _addNewTask() {
    context.goNamed(
      Routes.task,
      pathParameters: {'id': 'new'},
      extra: TaskInfoArguments(
        onSaveTask: (task) => _taskListBloc.add(
          TaskListEvent.add(task: task),
        ),
      ),
    );
  }

  _syncTaskList() {
    _taskListBloc.add(const TaskListSynch());
  }

  _toggleShowCompleted() {
    setState(() {
      isShowCompleted = !isShowCompleted;
    });
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
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
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
          ),
        );
      },
    );
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
      body: Wrapper(
        child: RefreshIndicator(
          onRefresh: () async {
            _syncTaskList();
          },
          child: CustomScrollView(
            slivers: <Widget>[
              const TaskListAppBar(),
              SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 32),
                      child: Text(
                        "${S.of(context)!.taskListCompleted}: $completed",
                        style: pageTheme.textTheme.bodyMedium
                            ?.apply(color: pageTheme.disabledColor),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 32),
                      child: IconButton(
                        onPressed: _toggleShowCompleted,
                        alignment: Alignment.center,
                        hoverColor: Colors.transparent,
                        color: Colors.blue,
                        splashRadius: 16,
                        icon: Icon(
                          _visibilityIcon,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: _blocBuilder(context),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: const Key('add_task_btn'),
        onPressed: _addNewTask,
        elevation: 0,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
