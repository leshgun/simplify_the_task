import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/S.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

import 'package:simplify_the_task/presentation/widgets/wrapper.dart';
import 'package:simplify_the_task/data/models/task/task_model.dart';

import 'task_info_route.dart';
import 'widgets/delete_button.dart';
import 'widgets/task_date_picker.dart';
import 'widgets/task_popup.dart';
import 'widgets/task_text.dart';

class TaskInfo extends StatefulWidget {
  final TaskInfoArguments? arguments;
  final Logger logger = Logger();

  TaskInfo({super.key, this.arguments});

  @override
  State<TaskInfo> createState() => _TaskInfoState();
}

class _TaskInfoState extends State<TaskInfo> {
  TaskModel? inputTask;
  bool deadlineIsOn = false;
  String taskText = '';
  int? taskPriority;
  DateTime? taskDeadline;

  // NavigatorState get _navigator => Navigator.of(context);

  TaskModel get task {
    inputTask ??= TaskModel(
      id: const Uuid().v4(),
      text: '',
      createdAt: DateTime.now(),
      changedAt: DateTime.now(),
    );
    return inputTask!.copyWith(
      text: taskText,
      priority: taskPriority,
      deadline: taskDeadline,
    );
  }

  void _save() {
    if (widget.arguments?.onSaveTask == null) {
      return;
    }
    if (task.text.isEmpty) {
      widget.arguments?.onSaveTask!(
        task.copyWith(text: S.of(context)!.taskEmpty),
      );
    } else {
      widget.arguments?.onSaveTask!(task);
    }
  }

  void _update() {
    if (widget.arguments?.onUpdateTask == null) {
      return;
    }
    if (inputTask != null) {
      widget.arguments?.onUpdateTask!(task);
    }
  }

  void _delete() {
    if (widget.arguments?.onDeleteTask == null) {
      return;
    }
    if (inputTask != null) {
      widget.arguments?.onDeleteTask!(task);
    }
  }

  void _exit() {
    TaskInfoRoute.popScreen(context);
  }

  void deleteTask() {
    _delete();
    _exit();
  }

  void saveTask() {
    if (inputTask == null) {
    // if (widget.arguments?.onSaveTask != null) {
      _save();
    } else {
      _update();
    }
    _exit();
  }

  @override
  void initState() {
    super.initState();
    inputTask = widget.arguments?.inputTask;
    if (inputTask != null) {
      taskText = inputTask?.text ?? '';
      taskPriority = inputTask?.priority ?? 0;
      taskDeadline = inputTask?.deadline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final pageTheme = Theme.of(context);

    List<Widget> children = [
      TaskText(
        initText: taskText,
        onChange: (String text) {
          setState(() {
            taskText = text;
          });
        },
      ),
      TaskPopup(
        items: [
          S.of(context)!.taskPriorityNone,
          S.of(context)!.taskPriorityLow,
          S.of(context)!.taskPriorityHigh,
        ],
        initItem: taskPriority,
        priorityColor: widget.arguments?.taskPriorityColor ?? Colors.red,
        onItemChange: (value) {
          setState(() {
            taskPriority = value;
          });
        },
      ),
      TaskDatePicker(
        initDate: taskDeadline,
        onDateChange: (DateTime? newDate) {
          setState(() {
            taskDeadline = newDate;
          });
        },
      ),
      DeleteButton(
        disabled: inputTask == null,
        callback: deleteTask,
      )
    ];

    final boxWidth = MediaQuery.of(context).size.width;
    final pad = boxWidth > 800 ? (boxWidth - 800 + 32) / 2 : 16.0;
    const iconSize = 24.0;

    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        leadingWidth: pad + 2 * iconSize,
        leading: Padding(
          padding: EdgeInsets.only(left: pad),
          child: IconButton(
            icon: Icon(
              Icons.close,
              color: pageTheme.textTheme.labelMedium?.color,
              size: iconSize,
            ),
            // hoverColor: Colors.transparent,
            onPressed: _exit,
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: pad),
            child: TextButton(
              key: const Key('save_bth'),
              onPressed: saveTask,
              child: Text(
                S.of(context)!.taskSave,
                style: const TextStyle(color: Color(0xff0a84ff)),
              ),
            ),
          )
        ],
      ),
      body: Wrapper(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView.separated(
            itemBuilder: (_, index) => children[index],
            itemCount: children.length,
            separatorBuilder: (_, index) => Divider(
              // color: Colors.black26,
              color: (index > 0) ? pageTheme.dividerColor : Colors.transparent,
              thickness: index > 0 ? .5 : 0,
              height: 10,
            ),
          ),
        ),
      ),
    );
  }
}
