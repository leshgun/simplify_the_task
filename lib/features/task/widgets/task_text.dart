import 'package:flutter/material.dart';

class TaskText extends StatelessWidget {
  final String? initText;
  final Function(String text)? onChange;

  const TaskText({super.key, this.initText, this.onChange});

  @override
  Widget build(BuildContext context) {
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
        initialValue: initText ?? '',
        style: pageTheme.textTheme.bodyMedium,
        onChanged: (String text) {
          if (onChange != null) {
            onChange!(text);
          }
        },
      ),
    );
  }
}
