import 'package:flutter/material.dart';
import 'package:simplify_the_task/di/di.dart';
import 'package:simplify_the_task/presentation/router/router.dart';

import 'presentation/app.dart';

void main() async {
  await DI.init();
  runApp(App(myRouter: MyRouter()));
}
