import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/S.dart';

import 'router/router.dart';
import 'theme/dark_theme.dart';
import 'theme/light_theme.dart';

class App extends StatelessWidget {
  final MyRouter myRouter;

  const App({super.key, required this.myRouter});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp.router(
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
      ),
    );
  }
}
