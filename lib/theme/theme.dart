import 'package:flutter/material.dart';

const Map<String, dynamic> lightColors = {
  'separator': Color(0x33000000),
  'support': Color(0x0f000000),
  'label': <String, Color>{
    'primary': Color(0xff000000),
    'secondary': Color(0x99000000),
    'tertiary': Color(0x4d000000),
    'disabled': Color(0x26000000),
  },
  'color': <String, Color>{
    'red': Color(0xffff3b30),
    'green': Color(0xff34c759),
    'blue': Color(0xff007aff),
    'gray': Color(0xff8e8e93),
    'gray-light': Color(0xffd1d1d6),
    'white': Color(0xffffffff),
  },
  'back': <String, Color>{
    'primary': Color(0xfff7f6f2),
    'secondary': Color(0xffffffff),
    'elevated': Color(0xffffffff),
  }
};

const Map<String, dynamic> darkColors = {
  'separator': Color(0x33ffffff),
  'support': Color(0x52000000),
  'label': <String, Color>{
    'primary': Color(0xffffffff),
    'secondary': Color(0x99ffffff),
    'tertiary': Color(0x66ffffff),
    'disabled': Color(0x26ffffff),
  },
  'color': <String, Color>{
    'red': Color(0xffff453a),
    'green': Color(0xff32d74b),
    'blue': Color(0xff0a84ff),
    'gray': Color(0xff8e8e93),
    'gray-light': Color(0xff48484a),
    'white': Color(0xffffffff),
  },
  'back': <String, Color>{
    'primary': Color(0xff161618),
    'secondary': Color(0xff252528),
    'elevated': Color(0xff3c3c3f),
  }
};

const largeTitle = TextStyle(
  fontSize: 32,
  height: 38 / 32,
  fontWeight: FontWeight.w500,
);
const title = TextStyle(
  fontSize: 20,
  height: 32 / 20,
  fontWeight: FontWeight.w400,
);
const button = TextStyle(
  fontSize: 14,
  height: 24 / 14,
);
const body = TextStyle(
  fontSize: 16,
  height: 20 / 16,
  fontWeight: FontWeight.w400,
);
const subhead = TextStyle(
  fontSize: 14,
  height: 20 / 14,
  fontWeight: FontWeight.w400,
);

final lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: const Color(0xfff7f6f2),
  scaffoldBackgroundColor: const Color(0xfff7f6f2),
  shadowColor: const Color(0x26000000),
  disabledColor: const Color(0x46000000),
  iconTheme: const IconThemeData(color: Color(0x4d000000)),
  colorScheme: const ColorScheme.light().copyWith(
    primary: const Color(0xfff7f6f2),
    secondary: const Color(0xffffffff),
    tertiary: const Color(0xffffffff),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xff007aff),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
    filled: true,
    fillColor: const Color(0xffffffff),
    contentPadding: const EdgeInsets.all(24),
  ),
  textSelectionTheme: const TextSelectionThemeData(cursorColor: Colors.black),
  switchTheme: SwitchThemeData(
      trackColor: MaterialStateProperty.resolveWith((state) =>
          state.contains(MaterialState.selected)
              ? const Color.fromRGBO(10, 132, 255, .3)
              : null),
      thumbColor: MaterialStateProperty.resolveWith((state) =>
          state.contains(MaterialState.selected)
              ? const Color(0xff007aff)
              : null)),
  buttonTheme: const ButtonThemeData(
    disabledColor: Color(0x26ffffff),
    buttonColor: Color(0xff0a84ff),
  ),
  fontFamily: 'Roboto',
  textTheme: const TextTheme(
    titleLarge: title,
    titleMedium: title,
    titleSmall: subhead,
    bodyMedium: body,
    bodySmall: subhead,
    // labelMedium: subhead,
  ),
  appBarTheme: const AppBarTheme(
    color: Color(0xfff7f6f2),
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
  listTileTheme: const ListTileThemeData(
    dense: true,
  ),
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: const Color(0xff161618),
  scaffoldBackgroundColor: const Color(0xff161618),
  shadowColor: Colors.transparent,
  disabledColor: const Color(0x26ffffff),
  iconTheme: const IconThemeData(color: Color(0x66ffffff)),
  colorScheme: const ColorScheme.dark().copyWith(
    primary: const Color(0xff161618),
    secondary: const Color(0xff252528),
    tertiary: const Color(0x66ffffff),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xff0a84ff),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
    filled: true,
    fillColor: const Color(0xff252528),
    contentPadding: const EdgeInsets.all(24),
  ),
  textSelectionTheme: const TextSelectionThemeData(cursorColor: Colors.white),
  switchTheme: SwitchThemeData(
    trackColor: MaterialStateProperty.resolveWith((state) =>
        state.contains(MaterialState.selected)
            ? const Color.fromRGBO(10, 132, 255, .3)
            : null),
    thumbColor: MaterialStateProperty.resolveWith((state) =>
        state.contains(MaterialState.selected)
            ? const Color(0xff0a84ff)
            : null),
  ),
  buttonTheme: const ButtonThemeData(
    disabledColor: Color(0x26ffffff),
    buttonColor: Color(0xff0a84ff),
  ),
  fontFamily: 'Roboto',
  textTheme: TextTheme(
    titleLarge: title.apply(color: const Color(0xffffffff)),
    titleMedium: title,
    titleSmall: subhead.apply(color: const Color(0x66ffffff)),
    bodyMedium: body,
    bodySmall: subhead,
  ),
  appBarTheme: AppBarTheme(
    color: darkColors['back']['primary'],
    titleTextStyle: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
  listTileTheme: const ListTileThemeData(
    dense: true,
  ),
);
