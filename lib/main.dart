import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
<<<<<<< HEAD
import 'package:simplify_the_task/presentation/router/router.dart';
import 'package:simplify_the_task/presentation/theme/dark_theme.dart';
import 'package:simplify_the_task/presentation/theme/light_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/S.dart';
=======
import 'package:simplify_the_task/features/task_list/bloc/task_list_bloc.dart';
import 'package:simplify_the_task/router/router.dart';
import 'package:simplify_the_task/theme/dark_theme.dart';
import 'package:simplify_the_task/theme/light_theme.dart';
>>>>>>> 7091967 (theme decomposition)

void main() => runApp(MainApp());

class MainApp extends StatelessWidget {
  final log = Logger();
  final MyRouter myRouter = MyRouter();

  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    log.d('App has been started at ${DateTime.now().toString()}...');
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
    );
  }
}
