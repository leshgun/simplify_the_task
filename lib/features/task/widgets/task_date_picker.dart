import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/S.dart';

class TaskDatePicker extends StatefulWidget {
  final DateTime? initDate;
  final Function(DateTime? newDate)? onDateChange;

  const TaskDatePicker({
    super.key,
    this.initDate,
    this.onDateChange,
  });

  @override
  State<TaskDatePicker> createState() => _TaskDatePickerState();
}

class _TaskDatePickerState extends State<TaskDatePicker> {
  bool isDateHidden = false;

  @override
  void initState() {
    super.initState();
    if (widget.initDate == null) {
      isDateHidden = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final pageTheme = Theme.of(context);
    final DateFormat formatter = DateFormat('dd MMM yyyy');
    final DateTime initDate = widget.initDate ?? DateTime.now();

    return ListTile(
      title: Text(
        S.of(context)!.taskDeadline,
        style: pageTheme.textTheme.bodyMedium,
      ),
      subtitle: Text(
        formatter.format(initDate),
        style: pageTheme.textTheme.titleSmall?.apply(
          color: (isDateHidden || (widget.initDate == null))
              ? Colors.transparent
              : Colors.blue,
        ),
      ),
      onTap: () async {
        DateTime? newDate = await showDatePicker(
          context: context,
          initialDate: initDate,
          firstDate: DateTime.now(),
          lastDate: DateTime(2100),
          helpText: initDate.year.toString(),
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
        if (newDate == null) {
          return;
        }
        if (widget.onDateChange == null) {
          return;
        }
        setState(() {
          isDateHidden = false;
        });
        widget.onDateChange!(newDate);
      },
      trailing: Switch(
        onChanged: (bool value) async {
          setState(() {
            isDateHidden = !value;
          });
          if (widget.onDateChange != null) {
<<<<<<< HEAD
<<<<<<< HEAD
            widget.onDateChange!(value ? initDate : null);
=======
            widget.onDateChange!(initDate);
>>>>>>> 07b4506 (code review)
=======
            widget.onDateChange!(value ? initDate : null);
>>>>>>> da229dc (add localization)
          }
        },
        value: !isDateHidden,
      ),
    );
  }
}
