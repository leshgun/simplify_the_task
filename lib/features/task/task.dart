import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplify_the_task/features/task_list/bloc/task_list_bloc.dart';
import 'package:simplify_the_task/models/task_model.dart';
import 'widgets/delete_button.dart';
import 'widgets/task_date_picker.dart';
import 'widgets/task_popup.dart';
import 'widgets/task_text.dart';

class Task extends StatefulWidget {
  const Task({super.key});

  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task> {
  TaskListBloc get _taskListBloc => BlocProvider.of<TaskListBloc>(context);
  NavigatorState get _navigator => Navigator.of(context);
  TaskModel get _task {
    return TaskModel(
        id: inputTask?.id ?? DateTime.now().hashCode,
        completed: inputTask?.completed ?? false,
        description: taskDescription,
        priority: taskPriority,
        deadline: taskDeadline);
  }

  bool deadlineIsOn = false;
  String taskDescription = '';
  int? taskPriority;
  DateTime? taskDeadline;
  TaskModel? inputTask;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args == null) return;
    if (args is! TaskModel) return;
    setState(() {
      inputTask = args;
      taskDescription = args.description;
      if (args.priority != null) {
        taskPriority = args.priority!;
      }
      if (args.deadline != null) {
        taskDeadline = args.deadline;
      }
    });
  }

  void _saveTaskAndExit() {
    setState(() {
      if (inputTask == null) {
        if (taskDescription.isNotEmpty) {
          _taskListBloc.add(TaskAdd(_task));
        }
      } else {
        _taskListBloc.add(TaskUpdate(_task));
      }
      _navigator.pop();
    });
  }

  void _deleteTask() {
    setState(() {
      if (inputTask != null) {
        _taskListBloc.add(TaskDelete(_task));
      }
      _navigator.pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    final pageTheme = Theme.of(context);

    List<Widget> children = [
      TaskText(
        initText: taskDescription,
        onChange: (String text) {
          setState(() {
            taskDescription = text;
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
        onDateChange: (DateTime newDate) {
          setState(() {
            taskDeadline = newDate;
          });
        },
      ),
      DeleteButton(
        disabled: inputTask == null,
        callback: _deleteTask,
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
              onPressed: _saveTaskAndExit,
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
