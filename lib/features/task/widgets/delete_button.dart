import 'package:flutter/material.dart';

class DeleteButton extends StatelessWidget {
  final bool? disabled;
  final Function()? callback;

  const DeleteButton({
    super.key,
    this.disabled,
    this.callback,
  });

  @override
  Widget build(BuildContext context) {
    final pageTheme = Theme.of(context);
    bool isDisabled = disabled ?? false;
    return TextButton(
      onPressed: isDisabled ? null : callback,
      child: Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 16),
        child: Row(
          children: [
            Icon(
              Icons.delete,
              color: isDisabled ? pageTheme.disabledColor : Colors.red,
            ),
            const SizedBox(width: 10),
            Text(
              'Удалить',
              style: pageTheme.textTheme.bodyMedium?.apply(
                color: isDisabled ? pageTheme.disabledColor : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
