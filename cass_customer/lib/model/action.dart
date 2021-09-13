class Action {
  static const String ID = 'action_id';
  static const String _DESCRIPTION = 'action_description';
  static const String _PRICE = 'action_price';

  int? id;
  String? description;
  double? price;
  bool selected;
  int? taskId;

  Action({
    this.id,
    this.description,
    this.price,
    this.selected = true,
    this.taskId,
  });

  String get priceString => 'RM ${price?.toStringAsFixed(2)}';

  factory Action.fromJson(Map<String, dynamic>? json) {
    return Action(
      id: json?[ID],
      description: json?[_DESCRIPTION],
      price: json?[_PRICE] != null ? json![_PRICE].toDouble() : null,
      taskId: json?["task_id"],
    );
  }
}
