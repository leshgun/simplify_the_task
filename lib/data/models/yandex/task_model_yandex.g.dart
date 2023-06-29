// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model_yandex.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_TaskModelYandex _$$_TaskModelYandexFromJson(Map<String, dynamic> json) =>
    _$_TaskModelYandex(
      id: json['id'] as String,
      text: json['text'] as String,
      importance: json['importance'] as String,
      deadline: json['deadline'] as int?,
      done: json['done'] as bool,
      color: json['color'] as String?,
      createdAt: json['created_at'] as int,
      changedAt: json['changed_at'] as int,
      lastUpdatedBy: json['last_updated_by'] as String,
    );

Map<String, dynamic> _$$_TaskModelYandexToJson(_$_TaskModelYandex instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'importance': instance.importance,
      'deadline': instance.deadline,
      'done': instance.done,
      'color': instance.color,
      'created_at': instance.createdAt,
      'changed_at': instance.changedAt,
      'last_updated_by': instance.lastUpdatedBy,
    };
