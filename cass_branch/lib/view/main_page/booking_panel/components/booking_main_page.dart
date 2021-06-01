import 'package:cass_branch/api/reservation_api.dart';
import 'package:cass_branch/model/branch.dart';
import 'package:cass_branch/model/reservation.dart';
import 'package:cass_branch/utils/dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'add_booking_dialog.dart';
import 'booking_data_source.dart';
import 'booking_detail_dialog.dart';

class BookingMainPage extends StatefulWidget {
  static const String ROUTE = 'booking_main_page/';

  @override
  _BookingMainPageState createState() => _BookingMainPageState();
}

class _BookingMainPageState extends State<BookingMainPage> {
  BookingDataSource _bookingDataSource;
  List<Reservation> _reservations;
  List<Reservation> _filteredReservations;
  bool _isLoading;
  bool _isReservedChecked;
  bool _isServicingChecked;
  bool _isServicedChecked;
  bool _isCancelledChecked;
  DateTime _selectedDate;

  void _fetchReservation() async {
    setState(() => _isLoading = true);
    final response = await ReservationAPI.fetch(
      id: Branch.instance.id,
      type: ReservationAPI.TYPE_BRANCH,
    );
    setState(() {
      if (response.isSuccess) {
        _reservations = response.data;
        _filterReservation();
      } else
        DialogUtils.show(context, response.message);
      _isLoading = false;
    });
  }

  void _filterReservation() {
    _filteredReservations = (_isReservedChecked &&
            _isServicingChecked &&
            _isServicedChecked &&
            _isCancelledChecked)
        ? _reservations
        : _reservations
            .where((r) =>
                (r.status == Reservation.STATUS.reserved &&
                    _isReservedChecked) ||
                (r.status ==
                        Reservation.STATUS.servicing &&
                    _isServicingChecked) ||
                (r.status == Reservation.STATUS.serviced &&
                    _isServicedChecked) ||
                (r.status == Reservation.STATUS.cancelled &&
                    _isCancelledChecked))
            .toList();
    _bookingDataSource = BookingDataSource(_filteredReservations);
  }

  void _onFilter({
    @required bool reserved,
    @required bool servicing,
    @required bool serviced,
    @required bool cancelled,
  }) {
    setState(() {
      _isReservedChecked = reserved;
      _isServicingChecked = servicing;
      _isServicedChecked = serviced;
      _isCancelledChecked = cancelled;
      _filterReservation();
    });
  }

  @override
  void initState() {
    _reservations = [];
    _isLoading = false;
    _isReservedChecked = true;
    _isServicingChecked = true;
    _isServicedChecked = true;
    _isCancelledChecked = true;
    _fetchReservation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Booking',
            style: Theme.of(context)
                .textTheme
                .headline5
                .copyWith(color: Colors.white),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.today_outlined),
              tooltip: 'Make booking',
              onPressed: () => showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => AddBookingDialog(date: _selectedDate),
              ),
            ),
            _BookingStatusFilterPopupMenuButton(
              reserved: _isReservedChecked,
              servicing: _isServicingChecked,
              serviced: _isServicedChecked,
              cancelled: _isCancelledChecked,
              onFilter: _onFilter,
            ),
            IconButton(
              icon: Icon(Icons.refresh),
              tooltip: 'Refresh',
              onPressed: _fetchReservation,
            ),
          ],
        ),
        body: _BookingCalendar(_bookingDataSource, (d) => _selectedDate = d),
      ),
    );
  }
}

class _BookingCalendar extends StatelessWidget {
  final BookingDataSource _bookingDataSource;
  final void Function(DateTime) onCalendarClick;
  _BookingCalendar(this._bookingDataSource, this.onCalendarClick);

  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      timeZone: 'UTC',
      showNavigationArrow: true,
      showDatePickerButton: true,
      showCurrentTimeIndicator: true,
      allowedViews: [
        CalendarView.week,
        CalendarView.month,
        CalendarView.schedule,
      ],
      view: CalendarView.month,
      monthViewSettings: MonthViewSettings(
        showAgenda: true,
        dayFormat: 'EEE',
      ),
      dataSource: _bookingDataSource,
      onTap: (calendarTapDetails) {
        onCalendarClick(calendarTapDetails.date);
        if (calendarTapDetails.targetElement == CalendarElement.appointment) {
          showDialog(
            context: context,
            builder: (_) =>
                BookingDetailDialog(calendarTapDetails.appointments[0]),
          );
        }
      },
    );
  }
}

class _BookingStatusFilterPopupMenuButton extends StatelessWidget {
  final bool reserved;
  final bool servicing;
  final bool serviced;
  final bool cancelled;
  final void Function({
    @required bool reserved,
    @required bool servicing,
    @required bool serviced,
    @required bool cancelled,
  }) onFilter;

  _BookingStatusFilterPopupMenuButton({
    @required this.reserved,
    @required this.servicing,
    @required this.serviced,
    @required this.cancelled,
    @required this.onFilter,
  });

  @override
  Widget build(BuildContext context) {
    bool _reserved = reserved;
    bool _servicing = servicing;
    bool _serviced = serviced;
    bool _cancelled = cancelled;

    return PopupMenuButton(
      icon: Icon(Icons.filter_list),
      tooltip: 'Filter Status',
      itemBuilder: (context) => [
        PopupMenuItem<Widget>(
          child: Text(
            'Select the status to be filtered:',
            style: TextStyle(color: Colors.black),
          ),
          enabled: false,
          padding: EdgeInsets.symmetric(horizontal: 24.0),
        ),
        _checkbox(
          label: Reservation.STATUS.reserved,
          isChecked: _reserved,
          onChecked: (checked) => _reserved = checked,
        ),
        _checkbox(
          label: Reservation.STATUS.servicing,
          isChecked: _servicing,
          onChecked: (checked) => _servicing = checked,
        ),
        _checkbox(
          label: Reservation.STATUS.serviced,
          isChecked: _serviced,
          onChecked: (checked) => _serviced = checked,
        ),
        _checkbox(
          label: Reservation.STATUS.cancelled,
          isChecked: _cancelled,
          onChecked: (checked) => _cancelled = checked,
        ),
        PopupMenuItem<Widget>(child: Container(), enabled: false, height: 12),
        PopupMenuItem<Widget>(
          enabled: false,
          child: Center(
            child: ElevatedButton(
              child: Text('FILTER'),
              onPressed: () {
                onFilter(
                  reserved: _reserved,
                  servicing: _servicing,
                  serviced: _serviced,
                  cancelled: _cancelled,
                );
                Navigator.of(context).pop();
              },
            ),
          ),
        )
      ],
    );
  }

  PopupMenuItem<CheckboxListTile> _checkbox({
    @required String label,
    @required bool isChecked,
    Function onChecked,
  }) {
    return PopupMenuItem(
      enabled: false,
      child: StatefulBuilder(
        builder: (context, setState) {
          return CheckboxListTile(
            activeColor: Reservation.STATUS.colors[label],
            controlAffinity: ListTileControlAffinity.leading,
            value: isChecked,
            title: Text(label),
            onChanged: (checked) {
              setState(() => isChecked = checked);
              onChecked(checked);
            },
          );
        },
      ),
    );
  }
}
