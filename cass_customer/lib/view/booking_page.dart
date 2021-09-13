import 'package:cass_customer/api/booking_api.dart';
import 'package:cass_customer/model/booking.dart';
import 'package:cass_customer/model/customer.dart';
import 'package:cass_customer/utils/dialog_utils.dart';
import 'package:cass_customer/view/add_booking_page.dart';
import 'package:cass_customer/view/booking_detail_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:loading_overlay/loading_overlay.dart';

class BookingPage extends StatefulWidget {
  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  List<Booking>? _bookings;
  bool _isLoading = false;

  void _fetchBookings() async {
    setState(() => _isLoading = true);
    final response = await BookingAPI.fetch(Customer.instance!);
    response.isSuccess
        ? setState(() => _bookings = response.data!.reversed.toList())
        : DialogUtils.show(context, response.message!);
    setState(() => _isLoading = false);
  }

  @override
  void initState() {
    _fetchBookings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade100,
      body: LoadingOverlay(
        isLoading: _isLoading,
        child: _isLoading || _bookings == null
            ? Container()
            : ListView.builder(
                itemCount: _bookings!.length,
                itemBuilder: (context, index) {
                  final booking = _bookings![index];
                  final title = booking.car!.plateNo! +
                      " - " +
                      booking.car!.carModel!.name!;
                  final subtitle1 = booking.service!.name!;
                  final subtitle2 = booking.dateToServiceString! +
                      "  " +
                      booking.timeToServiceStartString! +
                      "-" +
                      booking.timeToServiceEndString!;
                  return Card(
                    elevation: 12,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    child: ListTile(
                      leading: Icon(
                        booking.getIconData(),
                        color: booking.getColor(),
                        size: 48,
                      ),
                      title: Text(
                        title,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            subtitle1,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4),
                          Text(subtitle2),
                        ],
                      ),
                      isThreeLine: true,
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chevron_right_rounded,
                            size: 36,
                          ),
                        ],
                      ),
                      onTap: () => Navigator.of(context).push<bool>(
                        MaterialPageRoute(
                          builder: (_) => BookingDetailPage(booking),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "fab_booking_page",
        onPressed: () async {
          final isAdded = await Navigator.of(context).push<bool>(
            MaterialPageRoute(builder: (_) => AddBookingPage()),
          );
          if (isAdded == true) _fetchBookings();
        },
        child: Icon(Icons.add),
        tooltip: "Add Booking",
      ),
    );
  }
}
