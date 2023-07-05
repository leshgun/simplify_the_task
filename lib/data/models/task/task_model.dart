import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';

part 'task_model.freezed.dart';
part 'task_model.g.dart';

@freezed
class TaskModel with _$TaskModel {
  const TaskModel._();

  const factory TaskModel({
    required String id,
    required String text,
    int? priority,
    @Default(false) bool completed,
    @TimestampSerializer() required DateTime createdAt,
    @TimestampSerializer() required DateTime changedAt,
    @TimestampSerializer() DateTime? deadline,
  }) = _TaskModel;

  factory TaskModel.fromJson(Map<String, dynamic> json) =>
      _$TaskModelFromJson(json);

  factory TaskModel.fromString(String string) {
    return TaskModel.fromJson(jsonDecode(string));
  }

  factory TaskModel.fromBase64(String string) {
    return TaskModel.fromString(utf8.decode(base64Decode(string)));
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }

  String toBase64() {
    return base64Encode(utf8.encode(toJsonString()));
  }
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
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    } catch (e, stacktrace) {
      logger.w('Cant deserialize a date (wrong format)', e, stacktrace);
    }
    return null;
  }

  @override
  toJson(DateTime? date) => date?.millisecondsSinceEpoch;
}
