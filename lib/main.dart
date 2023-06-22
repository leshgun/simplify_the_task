import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:simplify_the_task/router/router.dart';
import 'package:simplify_the_task/theme/dark_theme.dart';
import 'package:simplify_the_task/theme/light_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/S.dart';

void main() => runApp(const MainApp());

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final log = Logger();
    log.d('App has been started at ${DateTime.now().toString()}...');
    return MaterialApp(
      title: 'Simplify the task!',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      routes: routes,
      initialRoute: '/task-list',
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        // Locale('en'),
        Locale('ru'),
      ],
      // home:
    );
  }
}
