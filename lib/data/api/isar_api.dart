import 'dart:io';

import 'package:isar/isar.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

import 'constants/isar_api_constants.dart';

class IsarApi {
  Isar? isar;
  Directory? _directory;
  Logger logger = Logger();

  IsarApi({
    directory,
    isarInstance,
  })  : _directory = directory,
        isar = isarInstance;

  Future<Directory?> get directory async {
    await _checkDirectory();
    return _directory;
  }

  Future<void> _checkDirectory() async {
    if (_directory == null) {
      try {
        const String appDirName = IsarApiConstants.directoryName;
        final docDir = await getApplicationDocumentsDirectory();
        _directory = await Directory('${docDir.path}/$appDirName')
            .create(recursive: true);
      } catch (e, stacktrace) {
        logger.w(
          'Cant find the Documents directory. Maybe the application is running in a browser?',
          '',
          stacktrace,
        );
      }
    }
  }

  Future<void> closeIsar() async {
    if (isar == null) {
      return;
    }
    await isar!.close();
  }
}
