import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/S.dart';
import 'package:go_router/go_router.dart';
import 'package:simplify_the_task/features/task_info/task_info_route.dart';
import 'package:simplify_the_task/features/task_list/repositories/task_list_repository.dart';
import 'package:simplify_the_task/features/task_list/task_list_route.dart';
import 'package:simplify_the_task/presentation/theme/dark_theme.dart';
import 'package:simplify_the_task/presentation/theme/light_theme.dart';

class TestApp {
  static Widget build({TaskListRepository? repository, String locale = 'en'}) {
    final routes = {
      '/task-list': (context) => TaskListScreen(
            taskListArguments: TaskListArguments(
              taskListRepository: repository,
            ),
          ),
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
            taskListArguments: TaskListArguments(
              taskListRepository: repository,
            ),
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
  static Widget build({TaskListRepository? repository, String locale = 'en'}) {
    final TaskListArguments taskListArguments = TaskListArguments(
      taskListRepository: repository,
    );

    final TaskInfoArguments taskInfoArguments = TaskInfoArguments(
      onSaveTask: (task) => repository?.saveTask(task),
    );

    final GoRouter router = GoRouter(
      initialLocation: '/task-list',
      debugLogDiagnostics: true,
      routes: [
        GoRoute(
          name: 'home',
          path: '/',
          redirect: (context, state) => '/task-list',
          builder: (context, state) => const Center(
            child: Text('Hello there...'),
          ),
        ),
        TaskListRoute(
          name: 'task-list',
          path: '/task-list',
          taskListArguments: taskListArguments,
          routes: [
            TaskInfoRoute(
              name: 'task',
              path: ':id',
              taskInfoArguments: taskInfoArguments,
              routes: [],
            ).getRoute(),
          ],
        ).getRoute()
      ],
    );

    return MaterialApp.router(
      title: 'Simplify the test task!',
      debugShowCheckedModeBanner: false,
      // theme: lightTheme,
      // darkTheme: darkTheme,
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
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
