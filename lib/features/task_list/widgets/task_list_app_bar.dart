import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplify_the_task/features/task_list/bloc/task_list_bloc.dart';
import 'package:simplify_the_task/models/task_model.dart';

class TaskListAppBar extends StatelessWidget {
  final bool? visibility;
  final Function()? callback;

  const TaskListAppBar({
    super.key,
    this.visibility,
    this.callback,
  });

  IconData get _visibilityIcon {
    if (visibility == null) {
      return Icons.visibility;
    }
    if (visibility == false) {
      return Icons.visibility_off;
    }
    return Icons.visibility;
  }

  _onCallback() {
    if (callback == null) {
      return;
    }
    callback!();
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
              onPressed: _onCallback,
              alignment: Alignment.center,
              hoverColor: Colors.transparent,
              splashRadius: 24,
              icon: Icon(
                _visibilityIcon,
                color: Colors.blue,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
