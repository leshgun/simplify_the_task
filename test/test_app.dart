import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/S.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:simplify_the_task/features/task/task_info_screen.dart';
import 'package:simplify_the_task/features/task_list/repositories/task_list_repository.dart';
import 'package:simplify_the_task/features/task_list/task_list_screen.dart';
import 'package:simplify_the_task/presentation/theme/dark_theme.dart';
import 'package:simplify_the_task/presentation/theme/light_theme.dart';

class TestApp {
  static Widget build({TaskListRepository? repository, String locale = 'en'}) {
    final routes = {
      '/task-list': (context) => TaskListScreen(
            taskListRepository: repository,
          ),
      // '/task-info': (context) => const TaskInfoScreen(),
    };
    return MaterialApp(
      routes: routes,
      initialRoute: '/task-list',
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [Locale(locale)],
    );
  }
}

class TestFullApp {
  static Widget build({TaskListRepository? repository, String locale = 'en'}) {
    final routes = {
      '/task-list': (context) => TaskListScreen(
            taskListRepository: repository,
          ),
      '/task-info': (context) => const TaskInfoScreen(),
    };
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
      supportedLocales: [Locale(locale)],
    );
  }
}

class TestFullAppNavigator2 {
  static GoRouter getRouter({TaskListRepository? repository}) {
    return GoRouter(
      initialLocation: '/task-list',
      debugLogDiagnostics: true,
      routes: [
        GoRoute(
          path: '/task-list',
          builder: (context, state) => TaskListScreen(
            taskListRepository: repository,
          ),
        ),
        GoRoute(
          path: '/task-info',
          builder: (context, state) {
            final args = state.extra;
            if (args is! TaskInfoArguments) {
              Logger().w('Wrong arguments for screen "task-info"');
              return context.widget;
            }
            return TaskInfoScreen(arguments: args);
          },
        ),
      ],
    );
  }

  static Widget build({TaskListRepository? repository, String locale = 'en'}) {
    return MaterialApp.router(
      title: 'Simplify the task!',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      routerConfig: getRouter(repository: repository),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [Locale(locale)],
    );
  }
}
