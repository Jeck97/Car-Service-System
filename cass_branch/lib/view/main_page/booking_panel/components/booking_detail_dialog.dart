import 'package:cass_branch/api/reservation_api.dart';
import 'package:cass_branch/model/reservation.dart';
import 'package:cass_branch/utils/constants.dart';
import 'package:cass_branch/utils/dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class BookingDetailDialog extends StatefulWidget {
  final Reservation _reservation;
  BookingDetailDialog(this._reservation);

  @override
  _BookingDetailDialogState createState() =>
      _BookingDetailDialogState(_reservation);
}

class _BookingDetailDialogState extends State<BookingDetailDialog> {
  bool _isLoading = false;
  final Reservation _reservation;

  _BookingDetailDialogState(this._reservation);

  void _cancelReservation(BuildContext context) async {
    final confirmed = await DialogUtils.confirm(
      context,
      'Are you sure to cancel the booking of ${_reservation.car.customer.name}',
    );
    if (confirmed) {
      setState(() => _isLoading = true);
      final response = await ReservationAPI.update(
        _reservation.copyWith(status: Reservation.STATUS.cancelled),
      );
      if (response.isSuccess)
        setState(
          () => _reservation.status = Reservation.STATUS.cancelled,
        );
      DialogUtils.show(context, response.message);
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      child: AlertDialog(
        contentPadding: PADDING32,
        actionsPadding: PADDING24,
        title: DialogTitle('Booking Detail'),
        content: _BookingDetailContent(_reservation),
        actions: [
          if (_reservation.status != Reservation.STATUS.cancelled)
            DialogAction(
              label: 'CANCEL BOOKING',
              onPressed: () => _cancelReservation(context),
            ),
          DialogAction(
            label: 'CLOSE',
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}

class _BookingDetailContent extends StatelessWidget {
  final Reservation _reservation;
  _BookingDetailContent(this._reservation);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 700,
      height: 400,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _labelText(label: 'Reservation ID', value: '${_reservation.id}'),
            _labelText(
              label: 'Reserved Date',
              value: _reservation.dateTimeReservedString,
            ),
            _labelText(
              label: 'Service Date',
              value: _reservation.dateTimeToServiceString +
                  ' - ${_reservation.timeToServiceEndString}',
            ),
            _labelText(label: 'Status', value: _reservation.status),
            _labelText(label: 'Remark', value: _reservation.remark),
            _labelText(
              label: 'Customer Name',
              value: _reservation.car.customer.name,
            ),
            _labelText(label: 'Car Plate No', value: _reservation.car.plateNo),
            _labelText(
              label: 'Car Model',
              value: _reservation.car.carModel.name,
            ),
            _labelText(label: 'Service Name', value: _reservation.service.name),
            _labelText(
              label: 'Service Duration',
              value: '${_reservation.service.duration} minutes',
            ),
          ],
        ),
      ),
    );
  }

  Widget _labelText({
    @required String label,
    @required String value,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 200.0,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 24.0),
            child: Text(
              ': ',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 20.0),
            ),
          ),
        ],
      ),
    );
  }
}
