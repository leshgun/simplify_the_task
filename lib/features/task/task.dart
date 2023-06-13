import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplify_the_task/features/task_list/bloc/task_list_bloc.dart';
import 'package:simplify_the_task/models/task_model.dart';
import 'package:intl/intl.dart';

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

    Widget textForm = textFromField();
    Widget priorityWidget = _priorityTile();
    Widget calendar = _calendarTile(pageTheme, context);
    Widget deleteButton = _deleteButton();
    List<Widget> children = [textForm, priorityWidget, calendar, deleteButton];

    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.transparent,
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

  Widget textFromField() {
    final pageTheme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: pageTheme.colorScheme.secondary,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        autofocus: true,
        maxLines: 15,
        minLines: 3,
        initialValue: taskDescription,
        onChanged: (String text) {
          taskDescription = text;
        },
        style: pageTheme.textTheme.bodyMedium,
      ),
    );
  }

  TextButton _deleteButton() {
    final pageTheme = Theme.of(context);
    bool disabled = inputTask == null;
    return TextButton(
      onPressed: disabled ? null : _deleteTask,
      child: Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 16),
        child: Row(
          children: [
            Icon(
              Icons.delete,
              color: disabled ? pageTheme.disabledColor : Colors.red,
            ),
            const SizedBox(width: 10),
            Text(
              'Удалить',
              style: pageTheme.textTheme.bodyMedium?.apply(
                color: disabled ? pageTheme.disabledColor : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  ListTile _calendarTile(ThemeData pageTheme, BuildContext context) {
    final DateFormat formatter = DateFormat('dd MMM yyyy');

    return ListTile(
      title: Text(
        'Сделать до',
        style: pageTheme.textTheme.bodyMedium,
      ),
      subtitle: Text(
        formatter.format(taskDeadline ?? DateTime.now()),
        style: pageTheme.textTheme.titleSmall?.apply(
          color: deadlineIsOn ? Colors.blue : Colors.transparent,
        ),
      ),
      onTap: () async {
        DateTime? newDate = await showDatePicker(
          context: context,
          initialDate: taskDeadline ?? DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2100),
          helpText:
              taskDeadline?.year.toString() ?? DateTime.now().year.toString(),
          builder: (context, child) => Theme(
            data: pageTheme.copyWith(
              colorScheme: const ColorScheme.light().copyWith(
                primary: Colors.blue,
                onSurface: pageTheme.textTheme.bodyMedium?.color,
              ),
              dialogBackgroundColor: pageTheme.colorScheme.primary,
            ),
            child: child!,
          ),
        );
        setState(() {
          if (newDate != null) {
            taskDeadline = newDate;
            deadlineIsOn = true;
          }
        });
      },
      trailing: Switch(
        onChanged: (bool value) async {
          setState(() {
            taskDeadline ??= DateTime.now();
            deadlineIsOn = value;
          });
        },
        value: deadlineIsOn,
      ),
    );
  }

  Widget _priorityTile() {
    const List<String> priorityList = ['Нет', 'Низкий', 'Высокий'];
    final pageTheme = Theme.of(context);

    return PopupMenuButton(
      onSelected: (value) {
        setState(() {
          taskPriority = value;
        });
      },
      iconSize: 0,
      tooltip: '',
      child: ListTile(
        title: Text(
          'Важность',
          style: pageTheme.textTheme.bodyMedium,
        ),
        subtitle: Text(
          priorityList[taskPriority ?? 0],
          style: pageTheme.textTheme.titleSmall,
        ),
        contentPadding: const EdgeInsets.only(left: 16, right: 16),
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
            value: 0,
            child: Text('Нет', style: pageTheme.textTheme.bodyMedium)),
        PopupMenuItem(
            value: 1,
            child: Text('Низкий', style: pageTheme.textTheme.bodyMedium)),
        PopupMenuItem(
          value: 2,
          child: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: Text(
                  '!!',
                  style: pageTheme.textTheme.bodyMedium?.apply(
                    color: Colors.red,
                    // fontWeightDelta: 2,
                  ),
                ),
              ),
              Text(
                'Высокий',
                style: pageTheme.textTheme.bodyMedium?.apply(color: Colors.red),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
