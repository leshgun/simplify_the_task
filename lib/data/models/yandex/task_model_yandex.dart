import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_model_yandex.freezed.dart';
part 'task_model_yandex.g.dart';

@freezed
class TaskModelYandex with _$TaskModelYandex {
  const factory TaskModelYandex(
          {required String id,
          required String text,
          required String importance,
          int? deadline,
          required bool done,
          String? color,
          @JsonKey(name: 'created_at') required int createdAt,
          @JsonKey(name: 'changed_at') required int changedAt,
          @JsonKey(name: 'last_updated_by') required String lastUpdatedBy}) =
      _TaskModelYandex;

  factory TaskModelYandex.fromJson(Map<String, dynamic> json) =>
      _$TaskModelYandexFromJson(json);
}

// class TaskModelYandex {
//   final String id;
//   final String text;
//   final String importance;
//   final int? deadline;
//   final bool done;
//   final String? color;
//   final int createdAt;
//   final int changedAt;
//   final String lastUpdatedBy;

//   const TaskModelYandex({
//     required this.id,
//     required this.text,
//     required this.importance,
//     required this.done,
//     required this.createdAt,
//     required this.changedAt,
//     required this.lastUpdatedBy,
//     this.deadline,
//     this.color,
//   });

// factory TaskModelYandex.fromJson(Map<String, dynamic> json) {
//   return TaskModelYandex(
//     id: json['id'],
//     text: json['text'],
//     importance: json['importance'],
//     deadline: json['deadline'],
//     done: json['done'],
//     color: json['color'],
//     createdAt: json['created_at'],
//     changedAt: json['changed_at'],
//     lastUpdatedBy: json['last_updated_by'],
//   );
// }

// Map<String, dynamic> toJson() {
//   return {
//     'id': id,
//     'text': text,
//     'importance': importance,
//     'deadline': deadline,
//     'done': done,
//     'color': color,
//     'created_at': createdAt,
//     'changed_at': changedAt,
//     'last_updated_by': lastUpdatedBy
//   };
// }
// }
