import 'package:flutter/material.dart';

class TaskPopup extends StatelessWidget {
  final List<String> items;
  final int? initItem;
  final Function(dynamic value)? onItemChange;

  const TaskPopup({
    super.key,
    required this.items,
    this.initItem,
    this.onItemChange,
  });

  @override
  Widget build(BuildContext context) {
    final pageTheme = Theme.of(context);
    if (items.isEmpty) {
      return Container();
    }
    List<PopupMenuItem> popupItems = [];
    for (int i = 0; i < items.length; i++) {
      popupItems.add(_popupItem(i, pageTheme));
    }
    return PopupMenuButton(
      onSelected: (value) {
        if (onItemChange != null) {
          onItemChange!(value);
        }
      },
      iconSize: 0,
      tooltip: '',
      child: ListTile(
        title: Text(
          'Важность',
          style: pageTheme.textTheme.bodyMedium,
        ),
        subtitle: Text(
          items[initItem ?? 0],
          style: pageTheme.textTheme.titleSmall,
        ),
        contentPadding: const EdgeInsets.only(left: 16, right: 16),
      ),
      itemBuilder: (context) => popupItems,
    );
  }

  PopupMenuItem<int> _popupItem(int position, ThemeData pageTheme) {
    if (position + 1 == items.length) {
      return PopupMenuItem(
        value: position,
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
              items[position],
              style: pageTheme.textTheme.bodyMedium?.apply(color: Colors.red),
            ),
          ],
        ),
      );
    }
    return PopupMenuItem(
      value: position,
      child: Text(items[position], style: pageTheme.textTheme.bodyMedium),
    );
  }
}
