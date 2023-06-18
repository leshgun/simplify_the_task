import 'package:flutter/material.dart';

class CommonTextTheme extends TextTheme {
  @override
  TextStyle? get titleLarge => const TextStyle(
      fontSize: 20,
      height: 32 / 20,
      fontWeight: FontWeight.w500,
    )..merge(super.titleLarge);

  @override
  TextStyle? get titleMedium => const TextStyle(
      fontSize: 20,
      height: 32 / 20,
      fontWeight: FontWeight.w400,
    )..merge(super.titleMedium);

  @override
  TextStyle? get titleSmall => const TextStyle(
      fontSize: 14,
      height: 20 / 14,
      fontWeight: FontWeight.w400,
    )..merge(super.titleSmall);

  @override
  TextStyle? get bodyMedium => const TextStyle(
        fontSize: 16,
        height: 20 / 16,
        fontWeight: FontWeight.w400,
      )..merge(super.bodyMedium);

  @override
  TextStyle? get bodySmall => const TextStyle(
      fontSize: 14,
      height: 20 / 14,
      fontWeight: FontWeight.w400,
    )..merge(super.titleMedium);
}
