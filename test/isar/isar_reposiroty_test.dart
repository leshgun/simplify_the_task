import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:simplify_the_task/data/api/isar_api.dart';
import 'package:simplify_the_task/data/repositories/isar/isar.dart';

import 'isar_test_constants.dart';

void main() {
  // Since the PathProvider gives an error below, we will specify the storage
  // directory of the Isar test instance ourselves.
  // Error: "MissingPluginException(No implementation found for method
  // getApplicationDocumentsDirectory on channel
  // plugins.flutter.io/path_provider)"
  const String path = IsarTestConstants.testPath;
  late Directory directory;
  late IsarApi isarApi;

  setUp(() async {
    await Isar.initializeIsarCore(download: true);
    directory = await Directory(path).create(recursive: true);
    isarApi = IsarApi(directory: directory);
  });

  tearDown(() {
    if (directory.existsSync()) {
      directory.delete(recursive: true);
    }
  });

  test(
    'The instance of Isar is working on an open database.',
    () async {
      final IsarRepository isar = IsarRepository(isarApi: isarApi);

      final isarInstance = await isar.isarInstance;

      expect(isarInstance.isOpen, true);
      expect(isarInstance.directory, path);
      expect(isarInstance.path, '$path/TaskList.isar');
    },
  );
}
