import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:simplify_the_task/data/models/task/task_model.dart';

import '../bloc/task_list_bloc.dart';
import '../widgets/dismiss_background.dart';

class TaskTile extends StatefulWidget {
  final TaskModel task;
  final Color priorityColor;
  final Function()? onTaskTileTrailing;

  const TaskTile({
    super.key,
    required this.task,
    this.priorityColor = Colors.green,
    this.onTaskTileTrailing,
  });

  @override
  State<TaskTile> createState() => _TaskState();
}

class _TaskState extends State<TaskTile> {
  double dismissIconPadding = .0;

  get _bloc => BlocProvider.of<TaskListBloc>(context);

  void _toggleCheckbox() async {
    _bloc.add(TaskListToggle(task: widget.task));
  }

  void _taskDelete() async {
    _bloc.add(TaskListEvent.delete(task: widget.task));
  }

  void _onInfoTap() {
    if (widget.onTaskTileTrailing != null) {
      widget.onTaskTileTrailing!();
    }
  }

  void _onDismissUpdate(DismissUpdateDetails details, BuildContext context) {
    final pad = MediaQuery.of(context).size.width * details.progress - 64;
    setState(() {
      dismissIconPadding = pad < 0 ? 0 : pad;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pageTheme = Theme.of(context);
    String key = widget.key.toString();
    key = key.substring(3, key.length - 3);

    final Widget iconBlank;
    if (widget.task.priority != null && widget.task.priority == 2) {
      iconBlank = Icon(
        Icons.check_box_outline_blank,
        color: widget.priorityColor,
      );
    } else {
      iconBlank = const Icon(Icons.check_box_outline_blank);
    }
    const Icon iconCheck = Icon(Icons.check_box, color: Colors.green);

    final dismissCheckboxBlank = DismissBackground(
      color: Colors.green,
      icon: const Icon(Icons.check, color: Colors.white),
      padding: dismissIconPadding,
      alignment: Alignment.centerLeft,
    );
    final dismissCheckboxChecked = DismissBackground(
      color: Colors.amber,
      icon: const Icon(Icons.check_box_outline_blank, color: Colors.white),
      padding: dismissIconPadding,
      alignment: Alignment.centerLeft,
    );
    final dismissDelete = DismissBackground(
      color: Colors.red,
      icon: const Icon(Icons.delete, color: Colors.white),
      alignment: Alignment.centerRight,
      padding: dismissIconPadding,
    );

    return Dismissible(
      // key: Key('task_${widget.task.id}_dismissible'),
      key: Key('${key}_dismissible'),
      background:
          widget.task.completed ? dismissCheckboxChecked : dismissCheckboxBlank,
      secondaryBackground: dismissDelete,
      onUpdate: ((details) => _onDismissUpdate(details, context)),
      onDismissed: (direction) => _taskDelete(),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          _toggleCheckbox();
          return false;
        }
        return true;
      },
      child: ListTile(
        key: Key('${key}_tile'),
        hoverColor: Colors.transparent,
        title: _tileTitle(pageTheme),
        subtitle: _tileSubtitle(pageTheme),
        leading: widget.task.completed ? iconCheck : iconBlank,
        horizontalTitleGap: 0,
        titleAlignment: ListTileTitleAlignment.top,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        trailing: IconButton(
          onPressed: _onInfoTap,
          alignment: Alignment.topRight,
          padding: EdgeInsets.zero,
          iconSize: 24,
          icon: const Icon(Icons.info_outline),
        ),
        onTap: _toggleCheckbox,
      ),
    );
  }

  Widget _tileTitle(ThemeData pageTheme) {
    InlineSpan leading = const TextSpan();
    if (widget.task.priority != null) {
      switch (widget.task.priority) {
        case 1:
          leading = const WidgetSpan(
            child: Icon(
              Icons.arrow_downward,
              size: 16,
            ),
          );
          break;
        case 2:
          leading = TextSpan(
            text: '!! ',
            style: pageTheme.textTheme.bodyMedium?.apply(
              color: widget.priorityColor,
              fontWeightDelta: 2,
            ),
          );
          break;
        default:
      }
    }
    return RichText(
      text: TextSpan(
        children: <InlineSpan>[
          leading,
          TextSpan(
            text: widget.task.text,
            style: widget.task.completed
                ? pageTheme.textTheme.bodyMedium?.apply(
                    decoration: TextDecoration.lineThrough,
                    color: pageTheme.disabledColor,
                  )
                : pageTheme.textTheme.bodyMedium,
          ),
        ],
      ),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _tileSubtitle(ThemeData pageTheme) {
    final deadline = widget.task.deadline;
    if (deadline == null) {
      return Container();
    }
    final DateFormat formatter = DateFormat('dd MMM yyyy');
    return Text(
      formatter.format(deadline),
      style:
          pageTheme.textTheme.bodySmall?.apply(color: pageTheme.disabledColor),
    );
  }
}
