import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/S.dart';

class TaskListAppBar extends StatelessWidget {
  final bool? visibility;
  final Function()? onVisibility;

  const TaskListAppBar({super.key, this.visibility, this.onVisibility});

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

    return SliverAppBar(
      pinned: true,
      expandedHeight: 150,
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
