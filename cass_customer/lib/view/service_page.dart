// CaSS Customer – service_page.dart

import 'dart:async';
import 'dart:ui';

import 'package:cass_customer/api/booking_api.dart';
import 'package:cass_customer/api/service_api.dart';
import 'package:cass_customer/model/action.dart' as a;
import 'package:cass_customer/model/booking.dart';
import 'package:cass_customer/model/customer.dart';
import 'package:cass_customer/model/servicing.dart';
import 'package:cass_customer/utils/dialog_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:loading_overlay/loading_overlay.dart';

class ServicePage extends StatefulWidget {
  @override
  _ServicePageState createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  Booking? _booking;
  Servicing? _servicing;
  List<String>? _tasks;
  List<a.Action>? _actions;
  List<String>? _acceptedActions;
  Timer? _timer;
  bool _isLoading = false;
  int _currentStep = 0;
  int _currentProgress = 0;

  final _progressTitles = [
    "CHECKING CAR",
    "SELECT ACTIONS TO APPLY",
    "REPARING",
    "COMPLETED",
  ];

  void _fetchServicing() async {
    setState(() => _isLoading = true);
    _reset();
    final response =
        await BookingAPI.fetchServicing(customer: Customer.instance!);
    if (response.isSuccess) {
      setState(() {
        _servicing = response.data;
        _booking = response.data!.booking;
        _currentStep = response.data!.step!;
        _currentProgress = response.data!.progress!;
      });
      if (_servicing?.progress == 0)
        _fetchTasks();
      else if (_servicing?.progress == 1)
        _fetchActions();
      else if (_servicing?.progress == 2) _fetchAcceptedActions();
      if (_servicing?.progress != 1) {
        if (_timer != null && _timer!.isActive) _timer!.cancel();
        _timer = Timer.periodic(Duration(seconds: 10), _timerCallback);
      }
    }
    setState(() => _isLoading = false);
  }

  void _fetchTasks() async {
    setState(() => _isLoading = true);
    final response = await ServiceAPI.fetchTasks(_booking!.service!);
    if (response.isSuccess) {
      setState(() {
        _tasks = response.data?.map((t) => t.description!).toList()
          ?..add("Checking completed!\nPrepareing for next step...");
      });
    } else
      DialogUtils.show(context, response.message!);
    setState(() => _isLoading = false);
  }

  void _fetchActions() async {
    setState(() => _isLoading = true);
    final response = await ServiceAPI.fetchActions(
      service: _booking!.service!,
      actions: _servicing!.actions!.join(","),
    );
    if (response.isSuccess) {
      setState(() => _actions = response.data);
    } else
      DialogUtils.show(context, response.message!);
    setState(() => _isLoading = false);
  }

  void _fetchAcceptedActions() async {
    setState(() => _isLoading = true);
    final response = await ServiceAPI.fetchActions(
      service: _booking!.service!,
      actions: _servicing!.acceptedActions!.join(","),
    );
    if (response.isSuccess) {
      setState(() {
        _acceptedActions = response.data?.map((t) => t.description!).toList()
          ?..add("Repairing completed!\nPrepareing for next step...");
      });
    } else
      DialogUtils.show(context, response.message!);
    setState(() => _isLoading = false);
  }

  void _timerCallback(Timer timer) async {
    final response = await BookingAPI.fetchServicing(booking: _booking!);

    if (response.isSuccess) {
      if (response.data!.step! > _currentStep) {
        setState(() {
          _servicing = response.data;
          _currentStep = _servicing!.step!;
        });
      }
      if (response.data!.progress! > _currentProgress) {
        setState(() {
          _servicing = response.data;
          _currentStep = _servicing!.step!;
          _currentProgress = _servicing!.progress!;
        });
        if (_servicing!.progress == 1) {
          timer.cancel();
          _fetchActions();
        }
        if (_servicing!.progress == 3) timer.cancel();
      }
    }
  }

  void _onStepContinue() async {
    _servicing!.acceptedActions =
        _actions!.where((a) => a.selected).map((a) => a.id.toString()).toList();
    _servicing!.progress = _servicing!.progress! + 1;
    _servicing!.step = 0;
    _servicing!.totalStep = _servicing!.acceptedActions!.length;
    setState(() => _isLoading = true);
    final response = await BookingAPI.updateServicing(
      servicing: _servicing!,
      booking: _booking!,
    );
    if (response.isSuccess) {
      if (_timer != null && _timer!.isActive) _timer!.cancel();
      _timer = Timer.periodic(Duration(seconds: 10), _timerCallback);
      _fetchAcceptedActions();
      setState(() => _currentProgress++);
    } else
      DialogUtils.show(context, response.message!);
    setState(() => _isLoading = false);
  }

  void _reset() {
    setState(() {
      if (_timer != null && _timer!.isActive) _timer!.cancel();
      _booking = _servicing = _tasks = _actions = _acceptedActions = null;
      _currentStep = _currentProgress = 0;
    });
  }

  @override
  void initState() {
    _fetchServicing();
    super.initState();
  }

  @override
  void dispose() {
    if (_timer != null && _timer!.isActive) _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade100,
      body: LoadingOverlay(
        isLoading: _isLoading,
        child: _isLoading
            ? Container()
            : _servicing == null
                ? _noServicing()
                : Stepper(
                    currentStep: _currentProgress,
                    type: StepperType.vertical,
                    physics: ScrollPhysics(),
                    controlsBuilder: (_, {onStepCancel, onStepContinue}) {
                      return _currentProgress == 1 && _actions != null
                          ? Align(
                              alignment: Alignment.centerLeft,
                              child: ElevatedButton(
                                onPressed: onStepContinue,
                                child: Text("CONTINUE"),
                              ),
                            )
                          : Container();
                    },
                    onStepContinue: _onStepContinue,
                    steps: List.generate(_progressTitles.length, (index) {
                      return Step(
                        title: Text(
                          _progressTitles[index],
                          style: TextStyle(
                            color: index <= _currentProgress
                                ? Colors.indigo
                                : Colors.grey.shade600,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        content: _getStepContent(index),
                        isActive: _currentProgress >= index,
                        state: _currentProgress > index
                            ? StepState.complete
                            : StepState.indexed,
                      );
                    }),
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "fab_service_page",
        onPressed: _fetchServicing,
        child: Icon(Icons.refresh),
        tooltip: "Refresh",
      ),
    );
  }

  Widget _noServicing() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CircleAvatar(
          radius: 72,
          backgroundColor: Colors.white,
          child: Icon(
            Icons.handyman,
            size: 96,
            color: Colors.blueGrey,
          ),
        ),
        SizedBox(height: 12),
        Text(
          "No Servicing Car",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 72, vertical: 12),
          child: RichText(
            text: TextSpan(
              style: TextStyle(color: Colors.blueGrey.shade800, fontSize: 16),
              children: [
                TextSpan(text: "Please "),
                TextSpan(
                  text: "contact us",
                  style: TextStyle(
                    color: Colors.indigo,
                    fontWeight: FontWeight.bold,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = () {},
                ),
                TextSpan(text: " if your car doesn't service in time."),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _getStepContent(int index) {
    switch (index) {
      case 0:
        return _tasks == null ? _progressIndicator() : _content0();
      case 1:
        return _actions == null ? _progressIndicator() : _content1();
      case 2:
        return _acceptedActions == null ? _progressIndicator() : _content2();
      case 3:
        return Card(
          elevation: 4,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            child: Text(
              "Your car had completely serviced. You can pick-up your car before 8:00pm today. 😁",
              style: TextStyle(
                fontSize: 18,
                color: Colors.blueGrey.shade700,
              ),
            ),
          ),
        );
      default:
        return Container();
    }
  }

  Widget _content0() {
    return Card(
      elevation: 4,
      child: Container(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Text(
                  "${_servicing!.stepPercentage}%",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.indigo,
                  ),
                ),
                Container(
                  width: 150,
                  height: 150,
                  child: CircularProgressIndicator(
                    value: _servicing!.stepValue,
                    strokeWidth: 12,
                    backgroundColor: Colors.blueGrey.shade200,
                  ),
                ),
                Container(
                  width: 150,
                  height: 150,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.blueGrey.shade200,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            Text(
              _tasks![_currentStep],
              style: TextStyle(
                fontSize: 18,
                color: Colors.blueGrey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _content1() {
    return Column(
      children: [
        Text(
          "Your car need to perform the following actions after checking by our technical staff. Please select the actions which you agree to perform on your car:",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey.shade700,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 16),
        Card(
          elevation: 4,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              children: List.generate(_actions!.length, (index) {
                return CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  value: _actions![index].selected,
                  title: Text(_actions![index].description!),
                  onChanged: (value) {
                    setState(() {
                      _actions![index].selected = value ?? false;
                    });
                  },
                );
              }),
            ),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _content2() {
    return Card(
      elevation: 4,
      child: Container(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Text(
                    "${_servicing!.stepPercentage}%",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.indigo,
                    ),
                  ),
                  Container(
                    width: 150,
                    height: 150,
                    child: CircularProgressIndicator(
                      value: _servicing!.stepValue,
                      strokeWidth: 12,
                      backgroundColor: Colors.blueGrey.shade200,
                    ),
                  ),
                  Container(
                    width: 150,
                    height: 150,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.blueGrey.shade200,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            Text(
              _acceptedActions![_currentStep],
              style: TextStyle(
                fontSize: 18,
                color: Colors.blueGrey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _progressIndicator() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: CircularProgressIndicator(),
      ),
    );
  }
}
