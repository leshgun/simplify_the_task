// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_TaskModel _$$_TaskModelFromJson(Map<String, dynamic> json) => _$_TaskModel(
      id: json['id'] as int,
      text: json['text'] as String,
      completed: json['completed'] as bool? ?? false,
      priority: json['priority'] as int?,
      deadline: const TimestampSerializer().fromJson(json['deadline']),
    );

Map<String, dynamic> _$$_TaskModelToJson(_$_TaskModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'completed': instance.completed,
      'priority': instance.priority,
      'deadline': const TimestampSerializer().toJson(instance.deadline),
    };
