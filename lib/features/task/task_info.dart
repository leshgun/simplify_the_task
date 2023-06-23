import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:flutter_gen/gen_l10n/S.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:simplify_the_task/presentation/router/router.dart';
import 'package:uuid/uuid.dart';
import 'package:simplify_the_task/data/models/task/task_model.dart';
=======
import 'package:logger/logger.dart';
import 'package:simplify_the_task/models/task_model.dart';
<<<<<<< HEAD
>>>>>>> 07b4506 (code review)
=======
import 'package:uuid/uuid.dart';
<<<<<<< HEAD
>>>>>>> 49aa5b0 (add uuid)
=======
import 'package:flutter_gen/gen_l10n/S.dart';
>>>>>>> da229dc (add localization)

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

<<<<<<< HEAD
  // NavigatorState get _navigator => Navigator.of(context);

  TaskModel get task {
    inputTask ??= TaskModel(
      id: const Uuid().v4(),
      text: '',
      createdAt: DateTime.now(),
      changedAt: DateTime.now(),
    );
=======
  NavigatorState get _navigator => Navigator.of(context);
  TaskModel get task {
<<<<<<< HEAD
    inputTask ??= TaskModel(id: DateTime.now().hashCode, text: '');
>>>>>>> 07b4506 (code review)
=======
    inputTask ??= TaskModel(
      id: const Uuid().v4(),
      text: '',
    );
>>>>>>> 49aa5b0 (add uuid)
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
<<<<<<< HEAD
    // if (inputTask == null) {
    if (task.text.isEmpty) {
      widget.arguments?.onSaveTask!(
        task.copyWith(text: S.of(context)!.taskEmpty),
      );
    } else {
      widget.arguments?.onSaveTask!(task);
    }
  }
  // }
=======
    if (inputTask == null) {
      if (task.text.isEmpty) {
        widget.arguments?.onSaveTask!(
          task.copyWith(text: S.of(context)!.taskEmpty),
        );
      } else {
        widget.arguments?.onSaveTask!(task);
      }
    }
  }
>>>>>>> 07b4506 (code review)

  void _update() {
    if (widget.arguments?.onUpdateTask == null) {
      return;
    }
    if (inputTask != null) {
      widget.arguments?.onUpdateTask!(task);
    }
  }

  void _delete() {
<<<<<<< HEAD
    if (widget.arguments?.onDeleteTask == null) {
=======
    if (widget.arguments?.onUpdateTask == null) {
>>>>>>> 07b4506 (code review)
      return;
    }
    if (inputTask != null) {
      widget.arguments?.onDeleteTask!(task);
    }
  }

  void _exit() {
<<<<<<< HEAD
    // _navigator.pop();
    if (context.canPop()) {
      context.pop();
    } else {
      context.goNamed(Routes.taskList);
    }
=======
    _navigator.pop();
>>>>>>> 07b4506 (code review)
  }

  void deleteTask() {
    _delete();
    _exit();
  }

  void saveTask() {
<<<<<<< HEAD
    // if (inputTask == null) {
    if (widget.arguments?.onSaveTask != null) {
=======
    if (inputTask == null) {
>>>>>>> 07b4506 (code review)
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
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> da229dc (add localization)
        items: [
          S.of(context)!.taskPriorityNone,
          S.of(context)!.taskPriorityLow,
          S.of(context)!.taskPriorityHigh,
        ],
<<<<<<< HEAD
=======
        items: const ['Нет', 'Низкий', 'Высокий'],
>>>>>>> 07b4506 (code review)
=======
>>>>>>> da229dc (add localization)
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
<<<<<<< HEAD
<<<<<<< HEAD
        disabled: inputTask == null,
=======
        disabled: inputTask != null,
>>>>>>> 07b4506 (code review)
=======
        disabled: inputTask == null,
>>>>>>> da229dc (add localization)
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
<<<<<<< HEAD
          // onPressed: () => _navigator.pop(),
          onPressed: _exit,
=======
          onPressed: () => _navigator.pop(),
>>>>>>> 07b4506 (code review)
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: TextButton(
<<<<<<< HEAD
              key: const Key('save_bth'),
              onPressed: saveTask,
              child: Text(
                S.of(context)!.taskSave,
                style: const TextStyle(color: Color(0xff0a84ff)),
              ),
=======
              onPressed: saveTask,
<<<<<<< HEAD
              child: const Text('СОХРАНИТЬ',
                  style: TextStyle(color: Color(0xff0a84ff))),
>>>>>>> 07b4506 (code review)
=======
              child: Text(
                S.of(context)!.taskSave,
                style: const TextStyle(color: Color(0xff0a84ff)),
              ),
>>>>>>> da229dc (add localization)
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
