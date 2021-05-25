import 'package:cass_branch/model/car.dart';
import 'package:cass_branch/utils/constants.dart';
import 'package:cass_branch/utils/dialog_utils.dart';
import 'package:flutter/material.dart';

class CarDetailDialog extends StatelessWidget {
  final Car _car;
  CarDetailDialog(this._car);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: PADDING32,
      actionsPadding: PADDING24,
      title: DialogTitle('Car Detail'),
      content: _CarDetailDialog(_car),
      actions: [
        DialogAction(
          label: 'OK',
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}

class _CarDetailDialog extends StatelessWidget {
  final Car _car;
  _CarDetailDialog(this._car);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      height: 400,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _labelText(label: 'Car ID', value: '${_car.id}'),
            _labelText(label: 'Plate Number', value: _car.plateNo),
            _labelText(label: 'Brand', value: _car.carModel.carBrand.name),
            _labelText(label: 'Model', value: _car.carModel.name),
            _labelText(label: 'Body Type', value: _car.carModel.type),
            _labelText(
              label: 'Last Serviced Date',
              value: _car.dateFromService != null ? _car.dateFromService : '-',
            ),
            _labelText(
              label: 'Coming Service Date',
              value: _car.dateToService != null ? _car.dateToService : '-',
            ),
            if (_car.distanceTargeted != null && _car.distanceTargeted != 0)
              _labelText(
                label: 'Distance Traveled',
                value:
                    '${_car.distanceCompleted} / ${_car.distanceTargeted} km',
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
