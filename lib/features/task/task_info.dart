import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:simplify_the_task/models/task_model.dart';
import 'package:uuid/uuid.dart';

import 'task_info_screen.dart';
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

  NavigatorState get _navigator => Navigator.of(context);
  TaskModel get task {
    inputTask ??= TaskModel(
      id: const Uuid().v4(),
      text: '',
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
    if (inputTask == null) {
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
    if (widget.arguments?.onUpdateTask == null) {
      return;
    }
    if (inputTask != null) {
      widget.arguments?.onDeleteTask!(task);
    }
  }

  void _exit() {
    _navigator.pop();
  }

  void deleteTask() {
    _delete();
    _exit();
  }

  void saveTask() {
    if (inputTask == null) {
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
        items: const ['Нет', 'Низкий', 'Высокий'],
        initItem: taskPriority,
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
        disabled: inputTask != null,
        callback: deleteTask,
      )
    ];

    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: pageTheme.textTheme.labelMedium?.color,
          ),
          hoverColor: Colors.transparent,
          onPressed: () => _navigator.pop(),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: TextButton(
              onPressed: saveTask,
              child: const Text('СОХРАНИТЬ',
                  style: TextStyle(color: Color(0xff0a84ff))),
            ),
          )
        ],
      ),
      body: Padding(
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
    );
  }
}
