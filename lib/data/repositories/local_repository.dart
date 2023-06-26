import 'dart:io';

import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

class LocalRepository {
  late Future<Directory> appDirectory;
  final Logger logger = Logger();

  String directoryName;

  //

  LocalRepository({required this.directoryName}) {
    createAppDirectory();
  }

  Future<String> readFromFile(String filename) {
    return appDirectory.then((Directory directory) =>
        File('${directory.path}/$filename').readAsString().then(
          (value) => value,
          onError: (error) {
            logger.w('Cant read from file "$directoryName/$filename"');
            logger.w(error);
          },
        ));
  }

  void saveDataToFile(String filename, String data) async {
    Directory directory = await appDirectory;
    File('${directory.path}/$filename').create().then(
      (File file) => file.writeAsString(data),
      onError: (error) {
        logger.w('The file $filename could not be created.');
      },
    );
  }

  void createAppDirectory() async {
    final documentsPath = await getApplicationDocumentsDirectory();
    appDirectory = Directory('${documentsPath.path}/$directoryName')
        .create(recursive: true)
        .then(
      (value) => value,
      onError: (error) {
        logger.w('The directory could not be created.');
        logger.w(error);
      },
    );
  }
}
