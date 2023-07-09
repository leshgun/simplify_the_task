import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:simplify_the_task/presentation/router/router.dart';
import 'package:simplify_the_task/presentation/theme/dark_theme.dart';
import 'package:simplify_the_task/presentation/theme/light_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/S.dart';

void main() => runApp(DevApp());

class DevApp extends StatelessWidget {
  final log = Logger();
  final MyRouter myRouter = MyRouter(bannerText: 'DEV');

  DevApp({super.key});

  @override
  Widget build(BuildContext context) {
    log.d('Dev app has been started at ${DateTime.now().toString()}...');
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    return SafeArea(
      child: MaterialApp.router(
        title: '[DEV] Simplify the task!',
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
