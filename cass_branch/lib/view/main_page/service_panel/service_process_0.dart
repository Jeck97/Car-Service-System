import 'package:cass_branch/api/service_api.dart';
import 'package:cass_branch/model/action.dart' as a;
import 'package:cass_branch/model/reservation.dart';
import 'package:cass_branch/model/task.dart';
import 'package:cass_branch/utils/dialog_utils.dart';
import 'package:flutter/material.dart';

class ServiceProcess0 extends StatefulWidget {
  final Reservation reservation;
  final void Function(List<a.Action>) onStepNext;

  ServiceProcess0({
    @required this.reservation,
    @required this.onStepNext,
  });

  @override
  State<ServiceProcess0> createState() => _ServiceProcess0State();
}

class _ServiceProcess0State extends State<ServiceProcess0> {
  List<Task> _tasks;
  List<a.Action> _actions;

  void _fetchTasks() async {
    final response = await ServiceAPI.fetchTasks(widget.reservation.service);
    response.isSuccess
        ? setState(() => _tasks = response.data)
        : DialogUtils.show(context, response.message);
  }

  void _fetchActions() async {
    final response = await ServiceAPI.fetchActions(widget.reservation.service);
    response.isSuccess
        ? setState(() => _actions = response.data)
        : DialogUtils.show(context, response.message);
  }

  @override
  void initState() {
    _fetchTasks();
    _fetchActions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_actions == null) return Container();
    final servicing = widget.reservation.servicing;
    int currentStep = servicing.step;
    return Stepper(
      currentStep: currentStep,
      type: StepperType.vertical,
      controlsBuilder: (_, {onStepCancel, onStepContinue}) =>
          _stepControls(onStepContinue, onStepCancel),
      onStepContinue: () => widget.onStepNext(_actions),
      onStepCancel: () => setState(() {
        if (servicing.step > 0) servicing.step--;
      }),
      steps: List.generate(
        _tasks.length,
        (index) {
          return Step(
            title: Text(_tasks[index].description),
            content: _stepContent(_tasks[index]),
            isActive: currentStep >= index,
            state: currentStep > index
                ? StepState.complete
                : currentStep == index
                    ? StepState.editing
                    : StepState.indexed,
          );
        },
      ),
    );
  }

  Widget _stepControls(VoidCallback onStepContinue, VoidCallback onStepCancel) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          ElevatedButton(
            onPressed: onStepContinue,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text("NEXT", style: TextStyle(fontSize: 16)),
            ),
          ),
          SizedBox(width: 24),
          if (widget.reservation.servicing.step > 0)
            TextButton(
              onPressed: onStepCancel,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text("PREVIOUS", style: TextStyle(fontSize: 16)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _stepContent(Task task) {
    if (_actions == null) return Container();
    final actions = _actions.where((a) => a.task.id == task.id).toList();
    return Container(
      child: Column(
        children: List.generate(
          actions.length,
          (index) {
            return CheckboxListTile(
              value: actions[index].selected,
              title: Text(actions[index].description),
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (value) => setState(() {
                _actions[_actions.indexOf(actions[index])].selected =
                    actions[index].selected = value;
                widget.reservation.servicing.actions = _actions
                    .where((a) => a.selected)
                    .map((a) => a.id.toString())
                    .toList();
              }),
            );
          },
        ),
      ),
    );
  }
}
