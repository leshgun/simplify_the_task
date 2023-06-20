import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';

part 'task_model.freezed.dart';
part 'task_model.g.dart';

@freezed
class TaskModel with _$TaskModel {
  const factory TaskModel({
    required String id,
    required String text,
    @Default(false) bool completed,
    int? priority,
    @TimestampSerializer() DateTime? deadline,
  }) = _TaskModel;

  factory TaskModel.fromJson(Map<String, dynamic> json) =>
      _$TaskModelFromJson(json);
}

class TimestampSerializer implements JsonConverter<DateTime?, dynamic> {
  const TimestampSerializer();

  @override
  DateTime? fromJson(dynamic timestamp) {
    final Logger logger = Logger();
    if (timestamp == null) {
      return timestamp;
    }
    try {
      return timestamp.toDate();
    } catch (e) {
      logger.w('Cant deserialize a date (wrong format)');
      logger.w('e');
    }
    return null;
  }

  @override
  toJson(DateTime? date) => date?.toIso8601String();
}
