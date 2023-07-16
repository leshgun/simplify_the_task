import 'package:flutter/material.dart';
import 'package:simplify_the_task/di/di.dart';
import 'package:simplify_the_task/presentation/app.dart';
import 'package:simplify_the_task/presentation/router/router.dart';

import 'firebase/prod/firebase_options.dart';

void main() async {
  await DI.init();
  await FirebaseDI.init(DefaultFirebaseOptions.currentPlatform);
  runApp(App(myRouter: MyRouter()));
}
