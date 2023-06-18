import 'package:isar/isar.dart';

part 'task_model_isar.g.dart';

@collection
class TaskModelIsar {
  Id id = Isar.autoIncrement;
  String? text;
  bool? completed;
  DateTime? deadline;
  int? priority;
}
