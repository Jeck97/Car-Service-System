class Task {
  static const String ID = 'task_id';
  static const String _DESCRIPTION = 'task_description';

  int id;
  String description;

  Task({this.id, this.description});

  factory Task.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return Task(
      id: json[ID],
      description: json[_DESCRIPTION],
    );
  }
}
