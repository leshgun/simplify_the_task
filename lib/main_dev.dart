import 'package:flutter/material.dart';
import 'package:simplify_the_task/di/di.dart';
import 'package:simplify_the_task/presentation/app.dart';

import 'firebase/dev/firebase_options.dart';
import 'presentation/router/router.dart';

void main() async {
  await DI.init();
  await FirebaseDI.init(DefaultFirebaseOptions.currentPlatform);
  DI.logger.d('Dev app has been started at ${DateTime.now().toString()}...');
  runApp(
    App(myRouter: MyRouter(bannerText: 'DEV')),
  );
}
