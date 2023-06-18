import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskDatePicker extends StatefulWidget {
  final DateTime? initDate;
  final Function(DateTime newDate)? onDateChange;

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
        'Сделать до',
        style: pageTheme.textTheme.bodyMedium,
      ),
      subtitle: Text(
        formatter.format(initDate),
        style: pageTheme.textTheme.titleSmall?.apply(
          color: isDateHidden ? Colors.transparent : Colors.blue,
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
          widget.onDateChange!(initDate);
        },
        value: !isDateHidden,
      ),
    );
  }
}
