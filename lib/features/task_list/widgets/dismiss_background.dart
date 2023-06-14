import 'package:flutter/material.dart';

class DismissBackground extends StatelessWidget {
  final Icon? icon;
  final Color? color;
  final Alignment? alignment;

  const DismissBackground({
    super.key,
    this.icon,
    this.color,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment ?? Alignment.centerLeft,
      color: color ?? Colors.green,
      padding: const EdgeInsets.only(left: 24, right: 24),
      child: icon ?? const Icon(Icons.delete, color: Colors.white),
    );
  }
}
