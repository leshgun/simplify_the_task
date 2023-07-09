import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/S.dart';
import 'package:simplify_the_task/presentation/widgets/wrapper.dart';

class TaskListAppBar extends StatelessWidget {
  const TaskListAppBar({super.key, this.onIconPress, this.icon});

  final Function()? onIconPress;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: TaskListHeaderDelegate(
        expandedHeight: 150.0,
        onIconPress: onIconPress ?? () {},
        icon: icon ?? const Icon(Icons.question_mark),
      ),
    );
  }
}

class TaskListHeaderDelegate extends SliverPersistentHeaderDelegate {
  const TaskListHeaderDelegate({
    required this.expandedHeight,
    required this.onIconPress,
    required this.icon,
  });

  final double expandedHeight;
  final Function() onIconPress;
  final Widget icon;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    double progress = shrinkOffset / (maxExtent - minExtent);
    if (progress > 1) progress = 1;
    final pad = 16 + (60 - 16) * (1 - progress);
    return Stack(
      fit: StackFit.expand,
      clipBehavior: Clip.none,
      children: [
        Container(
          alignment: Alignment.bottomLeft,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            boxShadow: [
              BoxShadow(
                color: Color.lerp(
                      Colors.transparent,
                      Theme.of(context).shadowColor,
                      shrinkOffset / maxExtent,
                    ) ??
                    Colors.amber,
                spreadRadius: 4,
                blurRadius: 4,
              ),
            ],
          ),
          padding: EdgeInsets.only(
            // left: 9 / progress < 60 ? 9 / progress : 60,
            bottom: 14,
            left: pad,
            right: 24,
          ),
          child: Wrapper(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  S.of(context)!.taskListTitle,
                  style: TextStyle.lerp(
                    Theme.of(context).textTheme.titleLarge,
                    Theme.of(context).textTheme.titleMedium,
                    progress,
                  ),
                ),
                IconButton(
                  onPressed: onIconPress,
                  alignment: Alignment.lerp(
                      Alignment.centerRight, Alignment.bottomRight, progress),
                  hoverColor: Colors.transparent,
                  color: Colors.blue,
                  splashRadius: 16,
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                  icon: icon,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
