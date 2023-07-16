import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:simplify_the_task/di/firebase_di.dart';

export 'firebase_di.dart';

class DI {
  static Logger get logger => Logger();

  static Color get taskPriorityColor => FirebaseDI.taskPriorityColor;

  static Future<void> init() async {}
}
