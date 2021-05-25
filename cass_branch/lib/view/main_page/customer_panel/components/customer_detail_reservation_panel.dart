import 'package:cass_branch/api/car_api.dart';
import 'package:cass_branch/api/reservation_api.dart';
import 'package:cass_branch/model/car.dart';
import 'package:cass_branch/model/customer.dart';
import 'package:cass_branch/model/reservation.dart';
import 'package:cass_branch/utils/constants.dart';
import 'package:cass_branch/utils/dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'car_detail_dialog.dart';

class CustomerDetailReservationPanel extends StatefulWidget {
  final Customer _customer;
  final customerReservationPanelState = _CustomerDetailReservationPanelState();
  CustomerDetailReservationPanel(this._customer);

  @override
  _CustomerDetailReservationPanelState createState() =>
      customerReservationPanelState;

  void refresh() => customerReservationPanelState.init();
}

class _CustomerDetailReservationPanelState
    extends State<CustomerDetailReservationPanel> {
  final Car _allCar = Car(id: -1, plateNo: 'All Cars');
  final String _allStatus = 'All Status';

  bool _isLoading = false;
  List<Car> _cars;
  List<Reservation> _reservations = [];
  List<Reservation> _filteredReservations = [];
  Car _currentCar;
  String _currentStatus;
  int _sortColumnIndex;
  bool _sortAscending;

  void _fetchCars() async {
    setState(() => _isLoading = true);
    _cars = [_allCar];
    final response =
        await CarAPI.fetchByCustomerId(customerId: widget._customer.id);
    setState(() {
      response.isSuccess
          ? _cars.addAll(response.data)
          : DialogUtils.show(context, response.message);
      _isLoading = false;
    });
  }

  void _fetchReservations() async {
    setState(() => _isLoading = true);
    final response =
        await ReservationAPI.fetchByCustomerId(customerId: widget._customer.id);
    setState(() {
      response.isSuccess
          ? _reservations = response.data
          : DialogUtils.show(context, response.message);
      _filterTable();
      _isLoading = false;
    });
  }

  void _updateCurrentCar(Car selectedCar) {
    setState(() {
      _currentCar = selectedCar;
      _filterTable();
    });
  }

  void _updateCurrentStatus(String selectedStatus) {
    setState(() {
      _currentStatus = selectedStatus;
      _filterTable();
    });
  }

  void _filterTable() {
    _filteredReservations = _currentCar.id == _allCar.id
        ? _reservations
        : _reservations
            .where((reservation) => reservation.car.id == _currentCar.id)
            .toList();
    _filteredReservations = _currentStatus == _allStatus
        ? _filteredReservations
        : _filteredReservations
            .where((reservation) => reservation.status == _currentStatus)
            .toList();
  }

  void _updateSort(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  void _showCarDetailDialog(Car selectedCar) {
    Car car = _cars.firstWhere(
      (car) => car.id == selectedCar.id,
      orElse: () => null,
    );
    car != null
        ? showDialog(context: context, builder: (_) => CarDetailDialog(car))
        : DialogUtils.show(context, '${selectedCar.plateNo} not found.');
  }

  void init() {
    setState(() {
      _sortColumnIndex = 0;
      _sortAscending = true;
      _currentCar = _allCar;
      _currentStatus = _allStatus;
    });
    _fetchCars();
    _fetchReservations();
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ModalProgressHUD(
        inAsyncCall: _isLoading,
        child: Container(
          padding: PADDING24,
          decoration: BoxDecoration(
            color: Colors.lightBlue.shade100,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            children: <Widget>[
              _CustomerReservationHeader(
                cars: _cars,
                currentCar: _currentCar,
                currentStatus: _currentStatus,
                updateCurrentCar: _updateCurrentCar,
                updateCurrentStatus: _updateCurrentStatus,
              ),
              _CustomerReservationTable(
                reservations: _filteredReservations,
                sortColumnIndex: _sortColumnIndex,
                sortAscending: _sortAscending,
                onUpdateSort: _updateSort,
                onCarPressed: _showCarDetailDialog,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomerReservationHeader extends StatelessWidget {
  final List<Car> cars;
  final Car currentCar;
  final String currentStatus;
  final void Function(Car selectedCar) updateCurrentCar;
  final void Function(String selectedStatus) updateCurrentStatus;

  final List<String> _statuses = [
    'All Status',
    Reservation.statuses.reserved,
    Reservation.statuses.servicing,
    Reservation.statuses.serviced,
    Reservation.statuses.cancelled,
  ];

  _CustomerReservationHeader({
    @required this.cars,
    @required this.currentCar,
    @required this.currentStatus,
    @required this.updateCurrentCar,
    @required this.updateCurrentStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        _filterDropDownMenu(
          label: 'CAR',
          dropdownButton: DropdownButton(
            value: currentCar,
            items: List.generate(
              cars.length,
              (index) => DropdownMenuItem(
                child: Text(cars[index].plateNo),
                value: cars[index],
              ),
            ),
            onChanged: (selectedCar) => updateCurrentCar(selectedCar),
          ),
        ),
        _filterDropDownMenu(
          label: 'STATUS',
          dropdownButton: DropdownButton(
            value: currentStatus,
            items: List.generate(
              _statuses.length,
              (index) => DropdownMenuItem(
                child: Text(_statuses[index]),
                value: _statuses[index],
              ),
            ),
            onChanged: (selectedStatus) => updateCurrentStatus(selectedStatus),
          ),
        ),
      ],
    );
  }

  Widget _filterDropDownMenu({
    @required String label,
    @required DropdownButton dropdownButton,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: <Widget>[
          Text(label, style: BOLD),
          Text(': '),
          Padding(padding: PADDING08),
          dropdownButton,
        ],
      ),
    );
  }
}

class _CustomerReservationTable extends StatelessWidget {
  final List<Reservation> reservations;
  final int sortColumnIndex;
  final bool sortAscending;
  final void Function(int columnIndex, bool ascending) onUpdateSort;
  final void Function(Car car) onCarPressed;

  _CustomerReservationTable({
    @required this.reservations,
    @required this.sortColumnIndex,
    @required this.sortAscending,
    @required this.onUpdateSort,
    @required this.onCarPressed,
  });
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            sortColumnIndex: sortColumnIndex,
            sortAscending: sortAscending,
            columns: _reservationColumns,
            rows: _reservationRows,
          ),
        ),
      ),
    );
  }

  List<DataColumn> get _reservationColumns {
    return <DataColumn>[
      DataColumn(
        label: Text('ID', style: BOLD),
        numeric: true,
        onSort: (columnIndex, ascending) {
          reservations.sort((a, b) =>
              ascending ? a.id.compareTo(b.id) : b.id.compareTo(a.id));
          onUpdateSort(columnIndex, ascending);
        },
      ),
      DataColumn(
        label: Text('RESERVED DATE', style: BOLD),
        onSort: (columnIndex, ascending) {
          reservations.sort((a, b) => ascending
              ? a.datetimeReserved.compareTo(b.datetimeReserved)
              : b.datetimeReserved.compareTo(a.datetimeReserved));
          onUpdateSort(columnIndex, ascending);
        },
      ),
      DataColumn(
        label: Text('SERVICE DATE', style: BOLD),
        onSort: (columnIndex, ascending) {
          reservations.sort((a, b) => ascending
              ? a.datetimeToService.compareTo(b.datetimeToService)
              : b.datetimeToService.compareTo(a.datetimeToService));
          onUpdateSort(columnIndex, ascending);
        },
      ),
      DataColumn(label: Text('STATUS', style: BOLD)),
      DataColumn(label: Text('REMARK', style: BOLD)),
      DataColumn(label: Text('CAR', style: BOLD)),
      DataColumn(label: Text('SERVICE', style: BOLD)),
      DataColumn(label: Text('BRANCH', style: BOLD)),
    ];
  }

  List<DataRow> get _reservationRows {
    return List.generate(reservations.length, (index) {
      final reservation = reservations[index];
      return DataRow(
        cells: <DataCell>[
          DataCell(Text('${reservation.id}')),
          DataCell(Text(reservation.datetimeReserved)),
          DataCell(Text(reservation.datetimeToService)),
          DataCell(Text(reservation.status)),
          DataCell(
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 180.0),
              child: Tooltip(
                margin: EdgeInsets.symmetric(horizontal: 32.0),
                message: reservation.remark,
                textStyle: TextStyle(color: Colors.white),
                child: Text(
                  reservation.remark,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
          DataCell(
            Row(
              children: <Widget>[
                Text(reservation.car.plateNo),
                IconButton(
                  icon: Icon(Icons.info_outline, size: 20),
                  onPressed: () => onCarPressed(reservation.car),
                ),
              ],
            ),
          ),
          DataCell(Text(reservation.service.name)),
          DataCell(Text(reservation.branch.name)),
        ],
      );
    });
  }
}
