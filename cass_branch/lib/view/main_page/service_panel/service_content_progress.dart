import 'package:cass_branch/model/reservation.dart';
import 'package:flutter/material.dart';

class ServiceContentProgress extends StatelessWidget {
  final Reservation reservation;
  final List<String> _progressTitles = [
    "Checking",
    "Waiting Response",
    "Repairing",
    "Payment",
  ];

  ServiceContentProgress({
    @required this.reservation,
  });

  @override
  Widget build(BuildContext context) {
    if (reservation == null) return Container();
    final servicing = reservation.servicing;
    int currentStep =
        (servicing != null && servicing.id != null) ? servicing.progress : -1;
    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.timelapse, size: 26, color: Colors.blueGrey),
          title: Text(
            "PROGRESS",
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(fontWeight: FontWeight.bold, color: Colors.blueGrey),
          ),
          horizontalTitleGap: 0,
          contentPadding: EdgeInsets.zero,
        ),
        reservation.status == Reservation.STATUS.serviced
            ? _progressStepper(
                currentStep: 3,
                isActive: true,
                stepState: StepState.complete,
              )
            : currentStep < 0
                ? _progressStepper(
                    currentStep: 0,
                    isActive: false,
                    stepState: StepState.indexed,
                  )
                : ConstrainedBox(
                    constraints: BoxConstraints.tightFor(height: 75.0),
                    child: Stepper(
                      currentStep: currentStep,
                      type: StepperType.horizontal,
                      controlsBuilder: (_, {onStepCancel, onStepContinue}) =>
                          Container(),
                      steps: List.generate(
                        _progressTitles.length,
                        (index) => Step(
                          title: Text(_progressTitles[index]),
                          content: Container(),
                          isActive: currentStep >= index,
                          state: currentStep > index
                              ? StepState.complete
                              : StepState.indexed,
                        ),
                      ),
                    ),
                  ),
      ],
    );
  }

  Widget _progressStepper({
    @required int currentStep,
    @required bool isActive,
    @required StepState stepState,
  }) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(height: 75.0),
      child: Stepper(
        currentStep: currentStep,
        type: StepperType.horizontal,
        controlsBuilder: (_, {onStepCancel, onStepContinue}) => Container(),
        steps: List.generate(
          _progressTitles.length,
          (index) => Step(
            title: Text(_progressTitles[index]),
            content: Container(),
            isActive: isActive,
            state: stepState,
          ),
        ),
      ),
    );
  }
}
