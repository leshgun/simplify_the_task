import 'package:flutter/material.dart';

class DismissBackground extends StatelessWidget {
  final Icon? icon;
  final Color? color;
  final Alignment? alignment;
  final double? padding;

  const DismissBackground({
    super.key,
    this.icon,
    this.color,
    this.alignment,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    EdgeInsets pad = EdgeInsets.zero;
    if (alignment != null) {
      if (alignment!.x > 0) {
        pad = EdgeInsets.only(right: (padding ?? 0) + 16);
      } else {
        pad = EdgeInsets.only(left: (padding ?? 0) + 16);
      }
    }
    return Container(
      alignment: alignment ?? Alignment.centerLeft,
      color: color ?? Colors.green,
      padding: pad,
      child: icon ?? const Icon(Icons.delete, color: Colors.white),
    );
  }
}
