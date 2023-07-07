import 'package:flutter/material.dart';

class CustomBanner extends StatelessWidget {
  final Widget child;
  final String? text;

  const CustomBanner({super.key, required this.child, this.text});

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [child];
    if (text != null) {
      children.add(
        Align(
          alignment: Alignment.topLeft,
          child: Container(
            padding: const EdgeInsets.only(top: 48, left: 48),
            child: Banner(
              message: text ?? "Custom",
              location: BannerLocation.bottomEnd,
              color: Colors.deepPurple,
            ),
          ),
        ),
      );
    }
    return Stack(children: children);
  }
}
