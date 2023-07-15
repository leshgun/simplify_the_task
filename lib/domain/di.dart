import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

abstract class DI {
  static Logger logger = Logger();

  static Future<void> init() async {}

  static Future<void> initFirebase(FirebaseOptions firebaseOptions) async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(options: firebaseOptions);
    logger.d('Firebase initialized');
    _initCrashlytics();
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

  static FirebaseAnalytics get analytics => FirebaseAnalytics.instance;

  static FirebaseCrashlytics get crashlytics => FirebaseCrashlytics.instance;
}
