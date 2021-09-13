import 'package:cass_branch/model/action.dart' as a;
import 'package:cass_branch/model/reservation.dart';
import 'package:cass_branch/utils/constants.dart';
import 'package:flutter/material.dart';

import 'service_content_detail.dart';
import 'service_content_information.dart';
import 'service_content_progress.dart';

class ServiceContent extends StatelessWidget {
  final List<Reservation> reservations;
  final Reservation reservation;
  final VoidCallback onReservationStart;
  final void Function(List<a.Action>) onProgress0StepNext;
  final VoidCallback onProgress1StepNext;
  final VoidCallback onProgress2StepNext;
  final VoidCallback onProgress3StepNext;

  ServiceContent({
    @required this.reservations,
    @required this.reservation,
    @required this.onReservationStart,
    @required this.onProgress0StepNext,
    @required this.onProgress1StepNext,
    @required this.onProgress2StepNext,
    @required this.onProgress3StepNext,
  });
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: PADDING24,
            child: Column(
              children: <Widget>[
                ServiceContentInformation(
                  reservation: reservation,
                  onReservationStart: onReservationStart,
                ),
                SizedBox(height: 24),
                ServiceContentProgress(
                  reservation: reservation,
                ),
                SizedBox(height: 24),
                ServiceContentDetail(
                  reservation: reservation,
                  onProgress0StepNext: onProgress0StepNext,
                  onProgress1StepNext: onProgress1StepNext,
                  onProgress2StepNext: onProgress2StepNext,
                  onProgress3StepNext: onProgress3StepNext,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
