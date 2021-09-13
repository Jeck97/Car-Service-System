import 'package:cass_branch/model/reservation.dart';
import 'package:cass_branch/utils/constants.dart';
import 'package:flutter/material.dart';

class ServiceContentInformation extends StatelessWidget {
  final Reservation reservation;
  final void Function() onReservationStart;

  const ServiceContentInformation({
    @required this.reservation,
    @required this.onReservationStart,
  });
  @override
  Widget build(BuildContext context) {
    bool isData = reservation != null;
    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.info, size: 26, color: Colors.blueGrey),
          title: Text(
            "INFORMATION",
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(fontWeight: FontWeight.bold, color: Colors.blueGrey),
          ),
          horizontalTitleGap: 0,
          contentPadding: EdgeInsets.zero,
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.grey[400],
                offset: const Offset(2.0, 2.0),
                blurRadius: 2.0,
              ),
            ],
          ),
          child: Wrap(
            children: <Widget>[
              _infoItem(
                title: "CUSTOMER",
                icons: [Icons.person, Icons.phone, Icons.mail],
                infos: isData
                    ? [
                        reservation.car.customer.name,
                        reservation.car.customer.phoneNo,
                        reservation.car.customer.email ?? "-",
                      ]
                    : null,
              ),
              _infoItem(
                title: "CAR",
                icons: [Icons.pin, Icons.directions_car],
                infos: isData
                    ? [
                        reservation.car.plateNo,
                        reservation.car.carModel.name,
                      ]
                    : null,
              ),
              _infoItem(
                title: "SERVICE",
                icons: [Icons.handyman, Icons.today, Icons.schedule],
                infos: isData
                    ? [
                        reservation.service.name,
                        reservation.dateToServiceString,
                        reservation.timeToServiceStartString +
                            " - " +
                            reservation.timeToServiceEndString,
                      ]
                    : null,
              ),
            ],
          ),
        ),
        _buttonStart(),
      ],
    );
  }

  Widget _infoItem({
    @required String title,
    @required List<IconData> icons,
    @required List<String> infos,
  }) {
    if (infos == null) infos = List.filled(icons.length, "-");
    return Padding(
      padding: PADDING24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              icons.length,
              (index) => Container(
                constraints: BoxConstraints(minWidth: 200),
                child: Wrap(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: Icon(
                        icons[index],
                        color: Colors.blueGrey,
                        size: 18,
                      ),
                    ),
                    Text(
                      infos[index],
                      style: TextStyle(color: Colors.blueGrey, fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buttonStart() {
    if (reservation == null ||
        reservation.status != Reservation.STATUS.reserved) return Container();
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(top: 24),
        child: ElevatedButton(
          child: Padding(
            padding: PADDING08,
            child: Text("START SERVICING"),
          ),
          onPressed: onReservationStart,
        ),
      ),
    );
  }
}
