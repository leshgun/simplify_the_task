import 'package:flutter/material.dart';
import 'package:simplify_the_task/features/task_list/repositories/task_list_repository.dart';

import '../test/test_app.dart';

void runTestApp({TaskListRepository? repository, String locale = 'en'}) {
  runApp(TestFullAppNavigator2.build(repository: repository, locale: locale));
}
