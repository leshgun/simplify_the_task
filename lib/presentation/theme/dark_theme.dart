import 'package:flutter/material.dart';
import 'package:simplify_the_task/presentation/theme/text_theme.dart';

class DarkColors {
  static const Color backgroundColor = Color(0xff161618);
  static const Color supportSeparator = Color(0x33ffffff);
  static const Color supportOverlay = Color(0x52000000);
  static const Color labelPrimary = Color(0xffffffff);
  static const Color labelSecondary = Color(0x99ffffff);
  static const Color labelTerritory = Color(0x66ffffff);
  static const Color labelDisabled = Color(0x26ffffff);
  static const Color red = Color(0xffFF453A);
  static const Color green = Color(0xff32D74B);
  static const Color blue = Color(0xff0A84FF);
  static const Color gray = Color(0xff8E8E93);
  static const Color grayLight = Color(0xff48484A);
  static const Color white = Color(0xffffffff);
  static const Color backPrimary = Color(0xff161618);
  static const Color backSecondary = Color(0xff252528);
  static const Color backElevated = Color(0xff3C3C3F);
}

final darkTheme = ThemeData(
  fontFamily: 'Roboto',
  textTheme: CommonTextTheme().apply(bodyColor: DarkColors.white),
  brightness: Brightness.dark,
  primaryColor: DarkColors.backPrimary,
  scaffoldBackgroundColor: DarkColors.backPrimary,
  shadowColor: DarkColors.labelDisabled,
  disabledColor: DarkColors.labelDisabled,
  iconTheme: const IconThemeData(color: DarkColors.labelTerritory),
  appBarTheme: const AppBarTheme(
    color: DarkColors.backPrimary,
  ),
  colorScheme: const ColorScheme.dark().copyWith(
    primary: DarkColors.backPrimary,
    secondary: DarkColors.backSecondary,
    tertiary: DarkColors.labelTerritory,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: DarkColors.blue,
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    ),
    filled: true,
    fillColor: DarkColors.backSecondary,
    contentPadding: const EdgeInsets.all(24),
  ),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: DarkColors.labelPrimary,
    selectionColor: DarkColors.labelSecondary,
    selectionHandleColor: DarkColors.labelTerritory,
  ),
  switchTheme: SwitchThemeData(
    trackColor: MaterialStateProperty.resolveWith((state) =>
        state.contains(MaterialState.selected)
            ? DarkColors.blue.withOpacity(.3)
            : null),
    thumbColor: MaterialStateProperty.resolveWith((state) =>
        state.contains(MaterialState.selected) ? DarkColors.blue : null),
  ),
  buttonTheme: const ButtonThemeData(
    disabledColor: DarkColors.labelDisabled,
    buttonColor: DarkColors.labelPrimary,
  ),
  listTileTheme: const ListTileThemeData(
    dense: true,
    minVerticalPadding: 16,
  ),
);
