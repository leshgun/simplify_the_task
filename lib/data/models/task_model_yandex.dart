class TaskModelYandex {
  final String id;
  final String text;
  final String importance;
  final int? deadline;
  final bool done;
  final String? color;
  final int createdAt;
  final int changedAt;
  final String lastUpdatedBy;

  const TaskModelYandex(
      {required this.id,
      required this.text,
      required this.importance,
      required this.done,
      required this.createdAt,
      required this.changedAt,
      required this.lastUpdatedBy,
      this.deadline,
      this.color});

  factory TaskModelYandex.fromJson(Map<String, dynamic> json) {
    return TaskModelYandex(
      id: json['id'],
      text: json['text'],
      importance: json['importance'],
      deadline: json['deadline'],
      done: json['done'],
      color: json['color'],
      createdAt: json['created_at'],
      changedAt: json['changed_at'],
      lastUpdatedBy: json['last_updated_by'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'importance': importance,
      'deadline': deadline,
      'done': done,
      'color': color,
      'created_at': createdAt,
      'changed_at': changedAt,
      'last_updated_by': lastUpdatedBy
    };
  }
}
