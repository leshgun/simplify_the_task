import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:simplify_the_task/features/task/task_info_screen.dart';
import 'package:simplify_the_task/features/task_list/bloc/task_list_bloc.dart';
import 'package:simplify_the_task/features/task_list/widgets/dismiss_background.dart';
import 'package:simplify_the_task/models/task_model.dart';

enum TaskEvent { complete }

class TaskTile extends StatefulWidget {
  final TaskModel task;

  const TaskTile({
    super.key,
    required this.task,
  });

  @override
  State<TaskTile> createState() => _TaskState();
}

class _TaskState extends State<TaskTile> {
  get _bloc => BlocProvider.of<TaskListBloc>(context);

  void _toggleCheckbox() async {
    setState(() {
      _bloc.add(TaskListToggle(task: widget.task));
    });
  }

  void _taskDelete() async {
    setState(() {
      _bloc.add(TaskListDelete(task: widget.task));
    });
  }

  void _onInfoTap() {
    Navigator.of(context).pushNamed(
      '/task-info',
      arguments: TaskInfoArguments(
        inputTask: widget.task,
        onUpdateTask: (task) => _bloc.add(TaskListEvent.update(task: task)),
        onDeleteTask: (task) => _bloc.add(TaskListEvent.delete(task: task)),
      ),
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

    const dismissCheckboxBlank = DismissBackground(
      color: Colors.green,
      icon: Icon(Icons.check, color: Colors.white),
    );
    const dismissCheckboxChecked = DismissBackground(
      color: Colors.amber,
      icon: Icon(Icons.check_box_outline_blank, color: Colors.white),
    );
    const dismissDelete = DismissBackground(
      color: Colors.red,
      icon: Icon(Icons.delete, color: Colors.white),
      alignment: Alignment.centerRight,
    );

    return ClipRect(
      clipBehavior: Clip.antiAlias,
      child: Dismissible(
        key: UniqueKey(),
        background: widget.task.completed
            ? dismissCheckboxChecked
            : dismissCheckboxBlank,
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
