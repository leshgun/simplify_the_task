import 'dart:io';

import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'constants/isar_api_constants.dart';

class IsarApi {
  Isar? isar;
  Directory? _directory;

  IsarApi({directory}) : _directory = directory;

  Future<Directory> get directory async {
    await _checkDirectory();
    return _directory!;
  }

  Future<void> _checkDirectory() async {
    if (_directory == null) {
      const String appDirName = IsarApiConstants.directoryName;
      final docDir = await getApplicationDocumentsDirectory();
      _directory =
          await Directory('${docDir.path}/$appDirName').create(recursive: true);
    }
  }
}
