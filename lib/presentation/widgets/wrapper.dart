import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    const width = 800;
    final media = MediaQuery.of(context);
    final deviceSize = media.size;
    final hPadding =
        (deviceSize.width > width) ? (deviceSize.width - width) / 2 : .0;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hPadding),
      child: child,
    );
  }
}
