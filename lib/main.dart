import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
<<<<<<< HEAD
<<<<<<< HEAD
import 'package:simplify_the_task/presentation/router/router.dart';
import 'package:simplify_the_task/presentation/theme/dark_theme.dart';
import 'package:simplify_the_task/presentation/theme/light_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/S.dart';
=======
import 'package:simplify_the_task/features/task_list/bloc/task_list_bloc.dart';
=======
>>>>>>> 07b4506 (code review)
import 'package:simplify_the_task/router/router.dart';
import 'package:simplify_the_task/theme/dark_theme.dart';
import 'package:simplify_the_task/theme/light_theme.dart';
<<<<<<< HEAD
>>>>>>> 7091967 (theme decomposition)
=======
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/S.dart';
>>>>>>> da229dc (add localization)

void main() => runApp(MainApp());

class MainApp extends StatelessWidget {
  final log = Logger();
  final MyRouter myRouter = MyRouter();

  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    log.d('App has been started at ${DateTime.now().toString()}...');
<<<<<<< HEAD
    return MaterialApp.router(
      title: 'Simplify the task!',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      routerDelegate: myRouter.router.routerDelegate,
      routeInformationParser: myRouter.router.routeInformationParser,
      routeInformationProvider: myRouter.router.routeInformationProvider,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ru'),
      ],
=======
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
>>>>>>> 07b4506 (code review)
    );
  }
}
