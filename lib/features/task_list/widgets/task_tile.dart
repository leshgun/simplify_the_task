import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:simplify_the_task/features/task_list/bloc/task_list_bloc.dart';
import 'package:simplify_the_task/models/task_model.dart';

enum TaskEvent { complete }

class TaskTile extends StatefulWidget {
  final Function(int, TaskEvent)? callback;
  final TaskModel task;

  const TaskTile({
    super.key,
    required this.task,
    this.callback,
  });

  @override
  State<TaskTile> createState() => _TaskState();
}

class _TaskState extends State<TaskTile> {
  get _bloc => BlocProvider.of<TaskListBloc>(context);

  void _toggleCheckbox() async {
    setState(() {
      _bloc.add(ToggleTask(widget.task));
    });
  }

  void _taskDelete() async {
    setState(() {
      _bloc.add(TaskDelete(widget.task));
    });
  }

  void _onInfoTap() {
    Navigator.of(context).pushNamed(
      '/task-details',
      arguments: widget.task,
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final pageTheme = Theme.of(context);

    final Widget iconBlank;
    if (widget.task.priority != null && widget.task.priority == 2) {
      iconBlank = const Icon(
        Icons.check_box_outline_blank,
        color: Colors.red,
      );
    } else {
      iconBlank = const Icon(Icons.check_box_outline_blank);
    }
    const Icon iconCheck = Icon(Icons.check_box, color: Colors.green);

    const dismissCheckboxBlank = DismissBackgroundWidget(
      color: Colors.green,
      icon: Icon(Icons.check, color: Colors.white),
    );
    const dismissCheckboxChecked = DismissBackgroundWidget(
      color: Colors.amber,
      icon: Icon(Icons.check_box_outline_blank, color: Colors.white),
    );
    const dismissDelete = DismissBackgroundWidget(
      color: Colors.red,
      icon: Icon(Icons.delete, color: Colors.white),
      alignment: Alignment.centerRight,
    );

    return Dismissible(
      key: UniqueKey(),
      background:
          widget.task.completed ? dismissCheckboxChecked : dismissCheckboxBlank,
      movementDuration: const Duration(seconds: 1),
      resizeDuration: const Duration(seconds: 1),
      secondaryBackground: dismissDelete,
      onDismissed: (direction) => _taskDelete(),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          _toggleCheckbox();
          return false;
        }
        return true;
      },
      child: ListTile(
        hoverColor: Colors.transparent,
        title: _tileTitle(pageTheme),
        subtitle: _tileSubtitle(pageTheme),
        leading: widget.task.completed ? iconCheck : iconBlank,
        trailing: IconButton(
            icon: const Icon(Icons.info_outline), onPressed: _onInfoTap),
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
              color: Colors.red,
              fontWeightDelta: 2,
            ),
          );
          break;
        default:
      }
    }
    return RichText(
      text: TextSpan(
        // text: widget.task.description
        children: <InlineSpan>[
          leading,
          TextSpan(
            text: widget.task.description,
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

class DismissBackgroundWidget extends StatelessWidget {
  final Icon? icon;
  final Color? color;
  final Alignment? alignment;

  const DismissBackgroundWidget({
    super.key,
    this.icon,
    this.color,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment ?? Alignment.centerLeft,
      color: color ?? Colors.green,
      padding: const EdgeInsets.only(left: 24, right: 24),
      child: icon ?? const Icon(Icons.delete, color: Colors.white),
    );
  }
}
