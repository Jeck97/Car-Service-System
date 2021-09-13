import 'package:cass_branch/api/reservation_api.dart';
import 'package:cass_branch/model/branch.dart';
import 'package:cass_branch/model/reservation.dart';
import 'package:cass_branch/utils/constants.dart';
import 'package:cass_branch/utils/dialog_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class DashboardContentOverview extends StatefulWidget {
  @override
  State<DashboardContentOverview> createState() =>
      _DashboardContentOverviewState();
}

class _DashboardContentOverviewState extends State<DashboardContentOverview> {
  List<Reservation> _reservations;
  List<Reservation> _todayReservations;
  DateTime _todayStart;
  DateTime _todayEnd;

  void _fetchReservations() async {
    final response = await ReservationAPI.fetch(
      id: Branch.instance.id,
      type: ReservationAPI.TYPE_BRANCH,
    );
    if (response.isSuccess) {
      setState(() {
        _reservations = response.data;
        _todayReservations = _reservations
            .where((r) =>
                r.datetimeToService.isAfter(_todayStart) &&
                r.datetimeToService.isBefore(_todayEnd))
            .toList();
      });
    } else
      DialogUtils.show(context, response.message);
  }

  @override
  void initState() {
    final today = DateTime.now();
    _todayStart = DateTime.utc(today.year, today.month, today.day);
    _todayEnd = DateTime.utc(today.year, today.month, today.day, 23, 59, 59);
    _fetchReservations();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: PADDING24,
      margin: PADDING24,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BORDER_RADIUS08,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.grey,
            offset: const Offset(2.0, 2.0),
            blurRadius: 2.0,
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                Icons.view_column_rounded,
                size: 36,
                color: Colors.indigo,
              ),
              SizedBox(width: 12),
              Text(
                "RESERVATION OVERVIEW",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
            ],
          ),
          _reservations == null
              ? Container(
                  height: 200,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Row(
                  children: <Widget>[
                    _OverviewTile(
                      title: "RESERVED",
                      iconData: Icons.event_rounded,
                      color: Colors.blue,
                      total: _reservations
                          .where((r) =>
                              r.status == Reservation.STATUS.reserved ||
                              r.status == Reservation.STATUS.servicing)
                          .length,
                      today: _todayReservations
                          .where((r) =>
                              r.status == Reservation.STATUS.reserved ||
                              r.status == Reservation.STATUS.servicing)
                          .length,
                    ),
                    _OverviewTile(
                      title: "SERVICED",
                      iconData: Icons.event_available_rounded,
                      color: Colors.green,
                      total: _reservations
                          .where((r) => r.status == Reservation.STATUS.serviced)
                          .length,
                      today: _todayReservations
                          .where((r) => r.status == Reservation.STATUS.serviced)
                          .length,
                    ),
                    _OverviewTile(
                      title: "CANCELLED",
                      iconData: Icons.event_busy_rounded,
                      color: Colors.red,
                      total: _reservations
                          .where(
                              (r) => r.status == Reservation.STATUS.cancelled)
                          .length,
                      today: _todayReservations
                          .where(
                              (r) => r.status == Reservation.STATUS.cancelled)
                          .length,
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}

class _OverviewTile extends StatelessWidget {
  final String title;
  final IconData iconData;
  final MaterialColor color;
  final int total;
  final int today;

  _OverviewTile({
    @required this.title,
    @required this.iconData,
    @required this.color,
    @required this.total,
    @required this.today,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: PADDING08,
        padding: PADDING16,
        decoration: BoxDecoration(
          borderRadius: BORDER_RADIUS24,
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: <Color>[
              color.shade300,
              color.shade600,
            ],
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey,
              offset: const Offset(2.0, 2.0),
              blurRadius: 2.0,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Icon(
                  iconData,
                  color: Colors.white,
                  size: 28,
                ),
                SizedBox(width: 12),
                Flexible(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Total:",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                Text(
                  "$total",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 48,
                  ),
                ),
              ],
            ),
            Divider(thickness: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Today: $today",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.more_horiz_rounded,
                      color: Colors.white,
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
