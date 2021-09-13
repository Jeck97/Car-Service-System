class Servicing {
  static const String ID = 'sr_id';
  static const String _PROGRESS = 'sr_progress';
  static const String _STEP = 'sr_step';
  static const String _TOTAL_STEP = 'sr_step_total';
  static const String _ACTIONS = 'sr_actions';
  static const String _ACCEPTED_ACTIONS = 'sr_actions_accepted';

  int id;
  int progress;
  int step;
  int totalStep;
  List<String> actions;
  List<String> acceptedActions;

  Servicing({
    this.id,
    this.progress,
    this.step,
    this.totalStep,
    this.actions,
    this.acceptedActions,
  });

  factory Servicing.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return Servicing(
      id: json[ID],
      progress: json[_PROGRESS],
      step: json[_STEP],
      totalStep: json[_TOTAL_STEP],
      actions: json[_ACTIONS] != null ? json[_ACTIONS].split(",") : [],
      acceptedActions: json[_ACCEPTED_ACTIONS] != null
          ? json[_ACCEPTED_ACTIONS].split(",")
          : [],
    );
  }

  Map toJson() => {
        ID: id,
        _PROGRESS: progress,
        _STEP: step,
        _TOTAL_STEP: totalStep,
        _ACTIONS: actions.length != 0 ? actions.join(",") : null,
        _ACCEPTED_ACTIONS:
            acceptedActions.length != 0 ? acceptedActions.join(",") : null,
      };
}
