import 'package:cass_customer/model/booking.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BookingDetailPage extends StatelessWidget {
  final Booking booking;

  BookingDetailPage(this.booking);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.indigo.shade100,
        appBar: AppBar(
          title: Text("Detail of Booking"),
          actions: [
            if (booking.status! == Booking.STATUS_RESERVED)
              IconButton(onPressed: () {}, icon: Icon(Icons.delete_rounded))
          ],
        ),
        body: Column(
          children: [
            ListTile(
              leading: Icon(Icons.info_rounded),
              title: Text(booking.status!),
              horizontalTitleGap: 0,
            ),
            ListTile(
              leading: Icon(Icons.directions_car_rounded),
              title: Text(
                booking.car!.plateNo! + " - " + booking.car!.carModel!.name!,
              ),
              horizontalTitleGap: 0,
            ),
            ListTile(
              leading: Icon(Icons.handyman_rounded),
              title: Text(booking.service!.name!),
              horizontalTitleGap: 0,
            ),
            ListTile(
              leading: Icon(Icons.storefront_rounded),
              title: Text(booking.branch!.name!),
              horizontalTitleGap: 0,
            ),
            ListTile(
              leading: Icon(Icons.history_rounded),
              title: Text(booking.dateTimeReservedString!),
              horizontalTitleGap: 0,
            ),
            ListTile(
              leading: Icon(Icons.access_time_filled_rounded),
              title: Text(booking.dateTimeToServiceString!),
              horizontalTitleGap: 0,
            ),
            ListTile(
              leading: Icon(Icons.note_alt_rounded),
              title: Text(booking.remark!),
              horizontalTitleGap: 0,
            ),
          ],
        ));
  }
}
