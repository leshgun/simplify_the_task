import 'package:flutter/material.dart';
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
import 'package:flutter_gen/gen_l10n/S.dart';
=======
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplify_the_task/features/task_list/bloc/task_list_bloc.dart';
import 'package:simplify_the_task/models/task_model.dart';
>>>>>>> d5b4746 (equitable => freezed)
=======
>>>>>>> 7c8e3a0 (code review)
=======
import 'package:flutter_gen/gen_l10n/S.dart';
>>>>>>> da229dc (add localization)

class TaskListAppBar extends StatelessWidget {
  final bool? visibility;
  final Function()? onVisibility;
<<<<<<< HEAD
<<<<<<< HEAD

  const TaskListAppBar({super.key, this.visibility, this.onVisibility});
=======
  final Function()? onSync;

  const TaskListAppBar(
      {super.key,
      this.visibility,
      this.onVisibility,
      this.onSync});
>>>>>>> 203c2a7 (code review)
=======

  const TaskListAppBar(
      {super.key, this.visibility, this.onVisibility});
>>>>>>> da229dc (add localization)

  IconData get _visibilityIcon {
    if (visibility == null) {
      return Icons.visibility;
    }
    if (visibility == false) {
      return Icons.visibility_off;
    }
    return Icons.visibility;
  }

  @override
  Widget build(BuildContext context) {
    final pageTheme = Theme.of(context);
<<<<<<< HEAD
<<<<<<< HEAD
=======
    final state = context.watch<TaskListBloc>().state;
    final int completed = state.when(
      initial: () => 0,
      loading: () => 0,
      loaded: (List<TaskModel> taskList) =>
          taskList.where((TaskModel task) => task.completed).length,
    );
>>>>>>> d5b4746 (equitable => freezed)
=======
>>>>>>> 7c8e3a0 (code review)

    return SliverAppBar(
      pinned: true,
      expandedHeight: 150,
<<<<<<< HEAD
<<<<<<< HEAD
      // collapsedHeight: 80,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 24),
          child: IconButton(
            onPressed: onVisibility ?? () {},
            alignment: Alignment.center,
            hoverColor: Colors.transparent,
            color: Colors.blue,
            splashRadius: 24,
            icon: Icon(
              _visibilityIcon,
              size: 24,
            ),
          ),
        ),
<<<<<<< HEAD
      ],
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        expandedTitleScale: 1.6,
        titlePadding: const EdgeInsets.only(
          left: 32,
          bottom: 14,
        ),
        title: Text(
          S.of(context)!.taskListTitle,
          style: pageTheme.textTheme.titleLarge,
=======
      collapsedHeight: 64,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        expandedTitleScale: 1.6,
        background: Container(
          alignment: Alignment.bottomLeft,
=======
      // collapsedHeight: 80,
      actions: [
<<<<<<< HEAD
        Center(
>>>>>>> 7c8e3a0 (code review)
          child: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
              onPressed: _onCallback,
              alignment: Alignment.center,
              hoverColor: Colors.transparent,
              splashRadius: 24,
              icon: Icon(
                _visibilityIcon,
                color: Colors.blue,
                size: 24,
              ),
=======
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: IconButton(
            onPressed: onVisibility ?? () {},
            alignment: Alignment.center,
            hoverColor: Colors.transparent,
            color: Colors.blue,
            splashRadius: 24,
            icon: Icon(
              _visibilityIcon,
              size: 24,
>>>>>>> 203c2a7 (code review)
            ),
<<<<<<< HEAD
          ],
>>>>>>> d5b4746 (equitable => freezed)
=======
          ),
>>>>>>> 7c8e3a0 (code review)
        ),
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: IconButton(
            onPressed: onSync ?? () {},
            color: Colors.blue,
            hoverColor: Colors.transparent,
            splashRadius: 24,
            icon: const Icon(Icons.sync),
          ),
        )
=======
>>>>>>> da229dc (add localization)
      ],
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        expandedTitleScale: 1.6,
        titlePadding: const EdgeInsets.only(
          left: 32,
          bottom: 14,
        ),
        title: Text(
          S.of(context)!.taskListTitle,
          style: pageTheme.textTheme.titleLarge,
        ),
      ),
    );
  }
}
