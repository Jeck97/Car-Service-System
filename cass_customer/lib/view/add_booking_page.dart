import 'package:cass_customer/api/booking_api.dart';
import 'package:cass_customer/api/branch_api.dart';
import 'package:cass_customer/api/car_api.dart';
import 'package:cass_customer/api/service_api.dart';
import 'package:cass_customer/model/booking.dart';
import 'package:cass_customer/model/branch.dart';
import 'package:cass_customer/model/car.dart';
import 'package:cass_customer/model/customer.dart';
import 'package:cass_customer/model/service.dart';
import 'package:cass_customer/utils/date_utils.dart' as d;
import 'package:cass_customer/utils/dialog_utils.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';

class AddBookingPage extends StatefulWidget {
  @override
  State<AddBookingPage> createState() => _AddBookingPageState();
}

class _AddBookingPageState extends State<AddBookingPage> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _remarkController = TextEditingController();
  Car? _car;
  Branch? _branch;
  Service? _service;
  DateTime? _date;
  TimeOfDay? _time;
  bool _isLoading = false;

  void _onBook() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    final response = await BookingAPI.add(
      Booking(
        datetimeReserved: DateTime.now(),
        datetimeToService: DateTime(_date!.year, _date!.month, _date!.day).add(
          Duration(hours: _time!.hour, minutes: _time!.minute),
        ),
        status: Booking.STATUS_RESERVED,
        remark: _remarkController.text.trim().isEmpty
            ? Booking.REMARK_NO_REMARK
            : _remarkController.text.trim(),
        car: _car,
        service: _service,
        branch: _branch,
      ),
    );
    if (response.isSuccess) {
      Navigator.of(context).pop<bool>(true);
      DialogUtils.show(context, "Booking had made successful.");
    } else
      DialogUtils.show(context, response.message!);
    setState(() => _isLoading = false);
  }

  void _onSelectDate() async {
    final tomorrow = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day + 1,
    );
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _date ?? tomorrow,
      firstDate: tomorrow,
      lastDate: DateTime(
        tomorrow.year + 1,
        tomorrow.month,
        tomorrow.day - 1,
      ),
    );
    if (selectedDate != null) {
      _date = selectedDate;
      _dateController.text = d.DateUtils.fromDate(_date)!;
    }
  }

  List<TimeOfDay> _getTimes() {
    final times = <TimeOfDay>[];
    if (_service == null) return times;
    int serviceHour =
        (_service!.duration! / d.DateUtils.MINUTES_PER_HOUR).ceil();
    for (int hour = 8; hour < 21 - serviceHour; hour++)
      times.add(TimeOfDay(hour: hour, minute: 0));
    return times;
  }

  String _timeAsString(TimeOfDay timeOfDay) {
    final start = DateTime(DateTime.now().year).add(
      Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute),
    );
    final end = start.add(Duration(minutes: _service!.duration!));
    return d.DateUtils.fromTime(start)! + " - " + d.DateUtils.fromTime(end)!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade100,
      appBar: AppBar(title: Text("Make Booking")),
      body: LoadingOverlay(
        isLoading: _isLoading,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  DropdownSearch<Car>(
                    mode: Mode.MENU,
                    label: "CAR",
                    hint: "-- Select Car --",
                    itemAsString: (c) => "${c.plateNo!} - ${c.carModel!.name}",
                    validator: (c) => c == null ? "Car is required" : null,
                    onChanged: (c) => setState(() => _car = c),
                    onFind: (_) async =>
                        (await CarAPI.fetch(Customer.instance!)).data ?? [],
                  ),
                  SizedBox(height: 24),
                  DropdownSearch<Branch>(
                    mode: Mode.MENU,
                    label: "BRANCH",
                    hint: "-- Select Branch --",
                    itemAsString: (b) => b.name!,
                    validator: (b) => b == null ? "Branch is required" : null,
                    onChanged: (b) => setState(() {
                      _branch = b;
                      _service = null;
                    }),
                    onFind: (_) async => (await BranchAPI.fetch()).data ?? [],
                  ),
                  SizedBox(height: 24),
                  DropdownSearch<Service>(
                    enabled: _branch != null,
                    mode: Mode.MENU,
                    label: "SERVICE",
                    hint: "-- Select Service --",
                    selectedItem: _service,
                    itemAsString: (s) => s.name!,
                    validator: (s) => s == null ? "Car is required" : null,
                    onChanged: (s) => setState(() {
                      _service = s;
                      _time = null;
                    }),
                    onFind: (_) async =>
                        (await ServiceAPI.fetch(_branch!)).data ?? [],
                  ),
                  SizedBox(height: 24),
                  TextFormField(
                    readOnly: true,
                    controller: _dateController,
                    decoration: InputDecoration(
                      labelText: "DATE",
                      hintText: "-- Select Date --",
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(
                        Icons.calendar_today_outlined,
                      ),
                    ),
                    validator: (d) =>
                        d == null || d.isEmpty ? "Date is required" : null,
                    onTap: _onSelectDate,
                  ),
                  SizedBox(height: 24),
                  DropdownSearch<TimeOfDay>(
                    mode: Mode.MENU,
                    enabled: _service != null,
                    dropDownButton: Icon(Icons.schedule),
                    label: "TIME",
                    hint: '-- Select Time --',
                    selectedItem: _time,
                    items: _getTimes(),
                    itemAsString: _timeAsString,
                    onChanged: (t) => setState(() => _time = t),
                    validator: (t) => t == null ? 'Time is required' : null,
                  ),
                  SizedBox(height: 24),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    controller: _remarkController,
                    decoration: InputDecoration(
                      labelText: "REMARK",
                      hintText: "Leave some remark about this booking...",
                      border: OutlineInputBorder(),
                    ),
                    minLines: 1,
                    maxLines: 5,
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      child: Text(
                        "BOOK",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    onPressed: _onBook,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
