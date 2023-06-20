import 'package:flutter/material.dart';

class TaskListAppBar extends StatelessWidget {
  final bool? visibility;
  final Function()? onVisibility;
  final Function()? onSync;

  const TaskListAppBar(
      {super.key,
      this.visibility,
      this.onVisibility,
      this.onSync});

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
            ),
          ),
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
      ],
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        expandedTitleScale: 1.6,
        titlePadding: const EdgeInsets.only(
          left: 32,
          bottom: 14,
        ),
        title: Text("Мои дела", style: pageTheme.textTheme.titleLarge),
      ),
    );
  }
}
