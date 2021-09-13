import 'package:cass_branch/model/reservation.dart';
import 'package:cass_branch/utils/constants.dart';
import 'package:flutter/material.dart';

class ServiceAside extends StatelessWidget {
  final List<Reservation> reservations;
  final Reservation selectedReservation;
  final void Function(Reservation) onReservationSelected;

  ServiceAside({
    @required this.reservations,
    @required this.selectedReservation,
    @required this.onReservationSelected,
  });
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: 300,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              left: BorderSide(width: 8, color: Colors.blueGrey),
            ),
          ),
        ),
        Container(
          width: 300,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  color: Colors.blueGrey,
                  width: 300,
                  padding: PADDING16,
                  child: Text(
                    "TODAY SERVICES LIST",
                    style: Theme.of(context).textTheme.headline6.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                _scheduleItem(
                  color: Colors.red,
                  title: "SERVICING",
                  noResult: "No servicing car...",
                  reservations: reservations
                      .where((r) => r.status == Reservation.STATUS.servicing)
                      .toList(),
                ),
                _scheduleItem(
                  color: Colors.orange,
                  title: "UPCOMING",
                  noResult: "No upcoming service...",
                  reservations: reservations
                      .where((r) => r.status == Reservation.STATUS.reserved)
                      .toList(),
                ),
                _scheduleItem(
                  color: Colors.green,
                  title: "COMPLETED",
                  noResult: "No completed service...",
                  reservations: reservations
                      .where((r) => r.status == Reservation.STATUS.serviced)
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _scheduleItem({
    @required MaterialColor color,
    @required String title,
    @required String noResult,
    @required List<Reservation> reservations,
  }) {
    return Theme(
      data: ThemeData(
        primarySwatch: color,
        accentColor: color, // ignore: deprecated_member_use
        unselectedWidgetColor: color,
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border(left: BorderSide(width: 8, color: color)),
        ),
        child: ExpansionTile(
          initiallyExpanded: true,
          title: Text(
            title,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
          children: reservations.length == 0
              ? [ListTile(title: Center(child: Text(noResult)))]
              : List.generate(
                  reservations.length,
                  (index) {
                    final car = reservations[index].car;
                    return ListTile(
                      title: Text(
                        "${car.plateNo} - ${car.carModel.name}",
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        reservations[index].service.name +
                            "\n" +
                            reservations[index].timeToServiceStartString +
                            " - " +
                            reservations[index].timeToServiceEndString,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: _progressIndicator(reservations[index], color),
                      isThreeLine: true,
                      selected: selectedReservation != null &&
                          selectedReservation.id == reservations[index].id,
                      onTap: () => onReservationSelected(reservations[index]),
                    );
                  },
                ),
        ),
      ),
    );
  }

  Widget _progressIndicator(Reservation reservation, MaterialColor color) {
    final servicing = reservation.servicing;
    if (servicing == null ||
        servicing.id == null ||
        reservation.status != Reservation.STATUS.servicing)
      return Container(width: 0);
    return Stack(
      alignment: AlignmentDirectional.center,
      children: <Widget>[
        servicing.progress != 3
            ? Text("${servicing.progress + 1}", style: BOLD)
            : Icon(Icons.done),
        CircularProgressIndicator(
          color: color,
          backgroundColor: color[100],
          value: servicing.progress != 1
              ? servicing.step / servicing.totalStep
              : null,
        ),
      ],
    );
  }
}
