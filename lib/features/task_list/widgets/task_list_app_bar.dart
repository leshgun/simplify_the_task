import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/S.dart';

class TaskListAppBar extends StatelessWidget {

  const TaskListAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final pageTheme = Theme.of(context);

    return SliverAppBar(
      pinned: true,
      expandedHeight: 150,
      // collapsedHeight: 80,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        expandedTitleScale: 1.6,
        titlePadding: const EdgeInsets.only(
          left: 32,
          // bottom: 14,
        ),
        title: Text(
          S.of(context)!.taskListTitle,
          style: pageTheme.textTheme.titleLarge,
        ),
      ),
    );
  }
}
