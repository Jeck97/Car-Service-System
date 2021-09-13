import 'dart:async';

import 'package:cass_branch/api/reservation_api.dart';
import 'package:cass_branch/model/action.dart' as a;
import 'package:cass_branch/model/branch.dart';
import 'package:cass_branch/model/reservation.dart';
import 'package:cass_branch/utils/dialog_utils.dart';
import 'package:cass_branch/view/main_page/service_panel/service_aside.dart';
import 'package:cass_branch/view/main_page/service_panel/service_content.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ServicePanel extends StatefulWidget {
  @override
  _ServicePanelState createState() => _ServicePanelState();
}

class _ServicePanelState extends State<ServicePanel> {
  List<Reservation> _reservations;
  Reservation _selectedReservation;

  bool _isLoading;

  void _fetchReservations() async {
    setState(() => _isLoading = true);
    final response = await ReservationAPI.fetch(
      id: Branch.instance.id,
      type: ReservationAPI.TYPE_BRANCH,
      isToday: true,
    );
    response.isSuccess
        ? setState(() => _reservations = response.data)
        : DialogUtils.show(context, response.message);
    setState(() => _isLoading = false);
  }

  void _fetchServicing() async {
    setState(() => _isLoading = true);
    final response = await ReservationAPI.fetchServicing(_selectedReservation);
    if (response.isSuccess) {
      setState(() => _selectedReservation.servicing = response.data);
      _startTimer();
    } else if (response.message == "Result not found")
      setState(() => _selectedReservation.servicing = response.data);
    else
      DialogUtils.show(context, response.message);
    setState(() => _isLoading = false);
  }

  void _onReservationSelected(Reservation reservation) {
    setState(() => _selectedReservation = reservation);
    _startTimer();
  }

  void _onReservationStart() async {
    final confirmed = await DialogUtils.confirm(
      context,
      "Confirm to start the service of car " +
          _selectedReservation.car.plateNo +
          " - " +
          _selectedReservation.car.carModel.name +
          "?",
    );
    if (confirmed) {
      setState(() => _isLoading = true);
      final response = await ReservationAPI.update(
        _selectedReservation.copyWith(status: Reservation.STATUS.servicing),
      );
      if (response.isSuccess) {
        setState(
            () => _selectedReservation.status = Reservation.STATUS.servicing);
        _fetchServicing();
      } else
        DialogUtils.show(context, response.message);
      setState(() => _isLoading = false);
    }
  }

  void _onProgress0StepNext(List<a.Action> actions) {
    final servicing = _selectedReservation.servicing;
    if (servicing.step < servicing.totalStep) {
      setState(() {
        servicing.actions = actions
            .where((a) => a.selected)
            .map((a) => a.id.toString())
            .toList();
        servicing.step++;
        if (servicing.step == servicing.totalStep) {
          servicing.step = 0;
          servicing.totalStep = 1;
          servicing.progress++;
          _startTimer();
        }
      });
      ReservationAPI.updateServicing(servicing, _selectedReservation);
    }
  }

  void _onProgress1StepNext() {
    final servicing = _selectedReservation.servicing;
    setState(() {
      _selectedReservation.servicing.step++;
      servicing.step = 0;
      servicing.totalStep = servicing.actions.length;
      servicing.acceptedActions = servicing.actions;
      servicing.progress++;
    });
    ReservationAPI.updateServicing(servicing, _selectedReservation);
  }

  void _onProgress2StepNext() {
    final servicing = _selectedReservation.servicing;
    if (servicing.step < servicing.totalStep) {
      setState(() {
        servicing.step++;
        if (servicing.step == servicing.totalStep) {
          servicing.step = 1;
          servicing.totalStep = 1;
          servicing.progress++;
        }
      });
      ReservationAPI.updateServicing(servicing, _selectedReservation);
    }
  }

  void _onProgress3StepNext() async {
    final responseDelete =
        await ReservationAPI.deleteServicing(_selectedReservation.servicing);
    setState(() {
      _selectedReservation.status = Reservation.STATUS.serviced;
      _selectedReservation.servicing = null;
    });
    final responseUpdate = await ReservationAPI.update(_selectedReservation);
    responseDelete.isSuccess && responseUpdate.isSuccess
        ? DialogUtils.show(context, "Payment Successful")
        : DialogUtils.show(context, "Payment Failed");
  }

  void _startTimer() {
    final servicing = _selectedReservation.servicing;
    if (servicing.progress != 1) return;
    print("Timer ${servicing.id} is starting...");
    Timer.periodic(
      Duration(seconds: 10),
      (t) async {
        print("Retrieve servicing ${servicing.id}");
        final response =
            await ReservationAPI.fetchServicing(_selectedReservation);
        if (response.isSuccess && response.data.progress == 2) {
          setState(() => _selectedReservation.servicing = response.data);
          t.cancel();
        }
      },
    );
  }

  @override
  void initState() {
    _isLoading = false;
    _fetchReservations();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: Text(
            'Service',
            style: Theme.of(context)
                .textTheme
                .headline5
                .copyWith(color: Colors.white),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.settings),
              tooltip: "Manage Services",
              onPressed: () {},
            ),
          ],
        ),
        body: _reservations == null
            ? Container()
            : Row(
                children: <Widget>[
                  ServiceContent(
                    reservations: _reservations,
                    reservation: _selectedReservation,
                    onReservationStart: _onReservationStart,
                    onProgress0StepNext: _onProgress0StepNext,
                    onProgress1StepNext: _onProgress1StepNext,
                    onProgress2StepNext: _onProgress2StepNext,
                    onProgress3StepNext: _onProgress3StepNext,
                  ),
                  ServiceAside(
                    reservations: _reservations,
                    selectedReservation: _selectedReservation,
                    onReservationSelected: _onReservationSelected,
                  ),
                ],
              ),
      ),
    );
  }
}
