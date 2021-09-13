import 'package:cass_branch/api/service_api.dart';
import 'package:cass_branch/model/action.dart' as a;
import 'package:cass_branch/model/reservation.dart';
import 'package:cass_branch/utils/dialog_utils.dart';
import 'package:flutter/material.dart';

class ServiceProcess2 extends StatefulWidget {
  final Reservation reservation;
  final VoidCallback onStepNext;

  ServiceProcess2({
    @required this.reservation,
    @required this.onStepNext,
  });

  @override
  State<ServiceProcess2> createState() => _ServiceProcess2State();
}

class _ServiceProcess2State extends State<ServiceProcess2> {
  List<a.Action> _actions;

  void _fetchActions() async {
    final response = await ServiceAPI.fetchActions(
      widget.reservation.service,
      actions: widget.reservation.servicing.acceptedActions.join(","),
    );
    response.isSuccess
        ? setState(() => _actions = response.data)
        : DialogUtils.show(context, response.message);
  }

  @override
  void initState() {
    _fetchActions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_actions == null) return Container();
    int currentStep = widget.reservation.servicing.step;
    return Stepper(
      currentStep: currentStep,
      type: StepperType.vertical,
      controlsBuilder: (context, {onStepCancel, onStepContinue}) => Row(
        children: [
          TextButton(
            onPressed: onStepContinue,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Text("NEXT", style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
      onStepContinue: widget.onStepNext,
      steps: List.generate(
        _actions.length,
        (index) {
          return Step(
            title: Text(_actions[index].description),
            content: Container(),
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
}
