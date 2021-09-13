import 'task.dart';

class Action {
  static const String ID = 'action_id';
  static const String _DESCRIPTION = 'action_description';
  static const String _PRICE = 'action_price';

  int id;
  String description;
  double price;
  bool selected;
  Task task;

  Action({
    this.id,
    this.description,
    this.price,
    this.selected = false,
    this.task,
  });

  String get priceString => price.toStringAsFixed(2);

  factory Action.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return Action(
      id: json[ID],
      description: json[_DESCRIPTION],
      price: json[_PRICE].toDouble(),
      task: Task.fromJson(json),
    );
  }
}
