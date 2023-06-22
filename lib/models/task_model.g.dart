// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_TaskModel _$$_TaskModelFromJson(Map<String, dynamic> json) => _$_TaskModel(
      id: json['id'] as String,
      text: json['text'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      changedAt: DateTime.parse(json['changedAt'] as String),
      completed: json['completed'] as bool? ?? false,
      priority: json['priority'] as int?,
      deadline: const TimestampSerializer().fromJson(json['deadline']),
    );

Map<String, dynamic> _$$_TaskModelToJson(_$_TaskModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'createdAt': instance.createdAt.toIso8601String(),
      'changedAt': instance.changedAt.toIso8601String(),
      'completed': instance.completed,
      'priority': instance.priority,
      'deadline': const TimestampSerializer().toJson(instance.deadline),
    };
