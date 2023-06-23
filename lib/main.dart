import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:simplify_the_task/router/router.dart';
import 'package:simplify_the_task/theme/dark_theme.dart';
import 'package:simplify_the_task/theme/light_theme.dart';

void main() => runApp(const MainApp());

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final log = Logger();
    log.d('App has been started at ${DateTime.now().toString()}...');
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      routes: routes,
      initialRoute: '/task-list',
      // home:
    );
  }
}
