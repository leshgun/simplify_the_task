import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

import 'package:simplify_the_task/data/repositories/config/config_repository.dart';

class FirebaseDI {
  static Logger logger = Logger();
  static late ConfigRepository _configRepository;

  static FirebaseAnalytics get analytics => FirebaseAnalytics.instance;

  static FirebaseCrashlytics get crashlytics => FirebaseCrashlytics.instance;

  static FirebaseRemoteConfig get remoteConfig => FirebaseRemoteConfig.instance;

  static ConfigRepository get configRepository => _configRepository;

  static Color get taskPriorityColor {
    return Color(int.parse(FirebaseDI.configRepository.taskPriorityColor));
  }

  static Future<void> init(FirebaseOptions firebaseOptions) async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(options: firebaseOptions);
    logger.d('Firebase initialized');

    _initCrashlytics();
    _initRemoteConfig();
  }

  static void _initCrashlytics() {
    FlutterError.onError = (errorDetails) {
      logger.w('There is an error in FlutterError.onError');
      crashlytics.recordFlutterError(errorDetails);
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      logger.w('There is an error in PlatformDispatcher.onError');
      crashlytics.recordError(error, stack, fatal: true);
      return true;
    };

    logger.d('Crashlytics initialized');
  }

  static void _initRemoteConfig() {
    _configRepository = ConfigRepository(remoteConfig);
    _configRepository.init();
  }
}
