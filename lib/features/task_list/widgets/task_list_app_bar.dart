import 'package:flutter/material.dart';

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

    return SliverAppBar(
      pinned: true,
      expandedHeight: 150,
      // collapsedHeight: 80,
      actions: [
        Center(
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
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        stretchModes: [StretchMode.fadeTitle],
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
