import 'package:cass_branch/model/action.dart' as a;
import 'package:cass_branch/model/reservation.dart';
import 'package:cass_branch/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'service_process_0.dart';
import 'service_process_1.dart';
import 'service_process_2.dart';
import 'service_process_3.dart';

class ServiceContentDetail extends StatelessWidget {
  final Reservation reservation;
  final void Function(List<a.Action>) onProgress0StepNext;
  final VoidCallback onProgress1StepNext;
  final VoidCallback onProgress2StepNext;
  final VoidCallback onProgress3StepNext;

  ServiceContentDetail({
    @required this.reservation,
    @required this.onProgress0StepNext,
    @required this.onProgress1StepNext,
    @required this.onProgress2StepNext,
    @required this.onProgress3StepNext,
  });

  @override
  Widget build(BuildContext context) {
    if (reservation == null) return Container();
    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.handyman, size: 26, color: Colors.blueGrey),
          title: Text(
            "SERVICE DETAIL",
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(fontWeight: FontWeight.bold, color: Colors.blueGrey),
          ),
          horizontalTitleGap: 0,
          contentPadding: EdgeInsets.zero,
        ),
        _detailBody(),
      ],
    );
  }

  Widget _detailBody() {
    if (reservation.status == Reservation.STATUS.serviced)
      return Container(
        padding: PADDING32,
        margin: const EdgeInsets.only(top: 60),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Service Completed",
              style: TextStyle(
                color: Colors.blueGrey,
                fontWeight: FontWeight.bold,
                fontSize: 40,
              ),
            ),
            SizedBox(width: 12),
            Icon(
              Icons.check_circle_rounded,
              size: 40,
              color: Colors.blueGrey,
            ),
          ],
        ),
      );

    final servicing = reservation.servicing;
    if (servicing == null)
      return Center(
        child: Padding(
          padding: PADDING32,
          child: Icon(
            Icons.handyman_rounded,
            size: 100,
            color: Colors.blueGrey,
          ),
        ),
      );

    switch (servicing.progress) {
      case 0:
        return ServiceProcess0(
          reservation: reservation,
          onStepNext: onProgress0StepNext,
        );
      case 1:
        return ServiceProcess1(
          onStepNext: onProgress1StepNext,
        );
      case 2:
        return ServiceProcess2(
          reservation: reservation,
          onStepNext: onProgress2StepNext,
        );
      case 3:
        return ServiceProcess3(
          reservation: reservation,
          onStepNext: onProgress3StepNext,
        );
      default:
        return Container();
    }
  }
}
