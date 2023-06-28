import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:isar/isar.dart';
import 'package:simplify_the_task/data/repositories/isar_repository.dart';

class MockIsarRepository extends Mock implements IsarRepository {}

void main() {
  late IsarRepository sut;

  setUp(() async {
    sut = MockIsarRepository();
    await Isar.initializeIsarCore(download: true);
  });

  group('Initial values', () {
    test(
      'Documents directory is null at start',
      () {
        final docDir = sut.docDir;
        expect(docDir, null);
      },
    );

    test(
      'App directory is null at start',
      () {
        final appDir = sut.appDir;
        expect(appDir, null);
      },
    );
  });
}
