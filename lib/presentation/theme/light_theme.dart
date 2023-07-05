import 'package:flutter/material.dart';
import 'package:simplify_the_task/presentation/theme/text_theme.dart';

class LightColors {
  static const Color backgroundColor = Color(0xffE5E5E5);
  static const Color supportSeparator = Color(0x33000000);
  static const Color supportOverlay = Color(0x0f000000);
  static const Color labelPrimary = Color(0xff000000);
  static const Color labelSecondary = Color(0x99000000);
  static const Color labelTerritory = Color(0x4D000000);
  static const Color labelDisabled = Color(0x26000000);
  static const Color red = Color(0xffff3b30);
  static const Color green = Color(0xff34c759);
  static const Color blue = Color(0xff007aff);
  static const Color gray = Color(0xff8e8e93);
  static const Color grayLight = Color(0xffd1d1d6);
  static const Color white = Color(0xffffffff);
  static const Color backPrimary = Color(0xfff7f6f2);
  static const Color backSecondary = Color(0xffffffff);
  static const Color backElevated = Color(0xffffffff);
}

final lightTheme = ThemeData(
  fontFamily: 'Roboto',
  textTheme: CommonTextTheme(),
  brightness: Brightness.light,
  primaryColor: LightColors.backPrimary,
  scaffoldBackgroundColor: LightColors.backPrimary,
  shadowColor: LightColors.labelDisabled,
  disabledColor: LightColors.labelDisabled,
  iconTheme: const IconThemeData(color: LightColors.labelTerritory),
  colorScheme: const ColorScheme.light().copyWith(
    primary: LightColors.backPrimary,
    secondary: LightColors.backSecondary,
    tertiary: LightColors.backSecondary,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: LightColors.blue,
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    ),
    filled: true,
    fillColor: LightColors.backSecondary,
    contentPadding: const EdgeInsets.all(24),
  ),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: LightColors.labelPrimary,
    selectionColor: LightColors.grayLight,
    selectionHandleColor: LightColors.labelTerritory,
  ),
  switchTheme: SwitchThemeData(
    trackColor: MaterialStateProperty.resolveWith((state) =>
        state.contains(MaterialState.selected)
            ? LightColors.blue.withOpacity(.3)
            : null),
    thumbColor: MaterialStateProperty.resolveWith((state) =>
        state.contains(MaterialState.selected) ? LightColors.blue : null),
  ),
  buttonTheme: const ButtonThemeData(
    disabledColor: LightColors.labelDisabled,
    buttonColor: LightColors.labelPrimary,
  ),
  listTileTheme: const ListTileThemeData(
    dense: true,
    minVerticalPadding: 16,
  ),
);
