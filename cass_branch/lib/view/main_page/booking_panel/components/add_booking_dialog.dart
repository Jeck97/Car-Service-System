import 'package:cass_branch/api/branch_api.dart';
import 'package:cass_branch/api/car_api.dart';
import 'package:cass_branch/api/customer_api.dart';
import 'package:cass_branch/api/reservation_api.dart';
import 'package:cass_branch/api/service_api.dart';
import 'package:cass_branch/model/branch.dart';
import 'package:cass_branch/model/car.dart';
import 'package:cass_branch/model/customer.dart';
import 'package:cass_branch/model/reservation.dart';
import 'package:cass_branch/model/service.dart';
import 'package:cass_branch/utils/constants.dart';
import 'package:cass_branch/utils/date_utils.dart' as cass;
import 'package:cass_branch/utils/dialog_utils.dart';
import 'package:cass_branch/view/main_page/customer_panel/components/add_car_dialog.dart';
import 'package:cass_branch/view/main_page/customer_panel/components/add_customer_dialog.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class AddBookingDialog extends StatefulWidget {
  final Customer customer;
  final DateTime date;

  AddBookingDialog({this.customer, this.date});
  @override
  _AddBookingDialogState createState() => _AddBookingDialogState();
}

class _AddBookingDialogState extends State<AddBookingDialog> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _remarkController = TextEditingController();
  bool _isDateValid;
  DateTime _selectedDate;
  TimeOfDay _selectedTime;
  bool _isLoading;
  Customer _selectedCustomer;
  Car _selectedCar;
  Branch _selectedBranch;
  Service _selectedService;
  List<Customer> _customers;
  List<Car> _cars;
  List<Branch> _branches;
  List<Service> _services;

  void _fetchCustomers() async {
    setState(() => _isLoading = true);
    final response = await CustomerAPI.fetch();
    setState(() {
      response.isSuccess
          ? _customers = response.data
          : DialogUtils.show(context, response.message);
      _isLoading = false;
    });
  }

  void _fetchCars() async {
    setState(() => _isLoading = true);
    final response = await CarAPI.fetchByCustomer(_selectedCustomer);
    setState(() {
      response.isSuccess
          ? _cars = response.data
          : DialogUtils.show(context, response.message);
      _isLoading = false;
    });
  }

  void _fetchBranch() async {
    setState(() => _isLoading = true);
    final response = await BranchAPI.fetch();
    setState(() {
      response.isSuccess
          ? _branches = response.data
          : DialogUtils.show(context, response.message);
      _isLoading = false;
    });
  }

  void _fetchServices() async {
    setState(() => _isLoading = true);
    final response = await ServiceAPI.fetchByBranch(Branch.instance);
    setState(() {
      response.isSuccess
          ? _services = response.data
          : DialogUtils.show(context, response.message);
      _isLoading = false;
    });
  }

  void _onCustomerSelected(Customer customer) {
    setState(() {
      _selectedCar = null;
      _selectedCustomer = customer;
    });
    _fetchCars();
  }

  void _onBranchSelected(Branch branch) {
    setState(() {
      _selectedTime = null;
      _selectedService = null;
      _selectedBranch = branch;
    });
    _fetchServices();
  }

  bool _validateForm() {
    bool valid = true;
    if (!_formKey.currentState.validate()) {
      valid = false;
    }
    if (_dateController.text.isEmpty) {
      setState(() => _isDateValid = false);
      valid = false;
    }
    return valid;
  }

  void _onAdd() async {
    if (!_validateForm()) return;
    _formKey.currentState.save();
    setState(() => _isLoading = true);
    final response = await ReservationAPI.add(
      Reservation(
        datetimeReserved: DateTime.now(),
        datetimeToService: DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
        ).add(
          Duration(
            hours: _selectedTime.hour,
            minutes: _selectedTime.minute,
          ),
        ),
        status: Reservation.STATUS.reserved,
        remark: _remarkController.text.trim().isEmpty
            ? Reservation.NO_REMARK
            : _remarkController.text.trim(),
        car: _selectedCar,
        service: _selectedService,
        branch: _selectedBranch,
      ),
    );
    if (response.isSuccess) _onDismiss();
    DialogUtils.show(context, response.message);
    setState(() => _isLoading = false);
  }

  void _onDismiss() => Navigator.of(context).pop();

  List<TimeOfDay> _getTimes() {
    final times = <TimeOfDay>[];
    if (_selectedService == null) return times;
    int serviceHour =
        (_selectedService.duration / cass.DateUtils.MINUTES_PER_HOUR).ceil();
    for (int hour = 8; hour < 21 - serviceHour; hour++)
      times.add(TimeOfDay(hour: hour, minute: 0));
    return times;
  }

  @override
  void initState() {
    _isLoading = false;
    _isDateValid = true;
    _selectedCustomer = widget.customer;
    _customers = [];
    _fetchCustomers();
    _selectedCustomer != null ? _fetchCars() : _cars = [];
    _selectedBranch = Branch.instance;
    _branches = [];
    _fetchBranch();
    _fetchServices();
    DateTime today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day + 1,
    ).subtract(Duration(seconds: 1));
    if (widget.date != null && widget.date.isAfter(today)) {
      _selectedDate = widget.date;
      _dateController.text = cass.DateUtils.fromDate(_selectedDate);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      child: AlertDialog(
        contentPadding: PADDING32,
        actionsPadding: PADDING24,
        title: DialogTitle('Add New Booking'),
        content: Container(
          width: 840,
          height: 600,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _customerPanel(),
                  _carPanel(),
                  _branchPanel(),
                  _servicePanel(),
                  _dateTimePanel(),
                  _remarkPanel(),
                ],
              ),
            ),
          ),
        ),
        actions: [
          DialogAction(label: 'CANCEL', onPressed: _onDismiss),
          DialogAction(label: 'ADD', onPressed: _onAdd),
        ],
      ),
    );
  }

  Widget _labeledText(String label, Widget value) {
    return Container(
      padding: PADDING16,
      width: 420,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(label),
          ),
          Text(': '),
          Expanded(
            flex: 3,
            child: value,
          ),
          SizedBox(width: 16),
        ],
      ),
    );
  }

  Widget _customerPanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: PADDING16,
          child: Text(
            'Select Customer',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Wrap(
          children: [
            _labeledText(
              'Customer ID',
              DropdownSearch<Customer>(
                mode: Mode.MENU,
                showSearchBox: true,
                hint: '-- Select --',
                selectedItem: _selectedCustomer,
                items: _customers,
                itemAsString: (c) => c.id.toString(),
                filterFn: (c, filter) => c.id.toString().contains(filter),
                onChanged: _onCustomerSelected,
                validator: (c) => c == null ? 'Customer ID is required' : null,
              ),
            ),
            _labeledText(
              'Name',
              DropdownSearch<Customer>(
                mode: Mode.MENU,
                showSearchBox: true,
                hint: '-- Select --',
                selectedItem: _selectedCustomer,
                items: _customers,
                itemAsString: (c) => c.name,
                filterFn: (c, filter) =>
                    c.name.toLowerCase().contains(filter.toLowerCase()),
                onChanged: _onCustomerSelected,
                validator: (c) =>
                    c == null ? 'Customer name is required' : null,
              ),
            ),
            _labeledText(
              'Phone Number',
              DropdownSearch<Customer>(
                mode: Mode.MENU,
                showSearchBox: true,
                hint: '-- Select --',
                selectedItem: _selectedCustomer,
                items: _customers,
                itemAsString: (c) => c.phoneNo,
                filterFn: (c, filter) => c.phoneNo.contains(filter),
                onChanged: _onCustomerSelected,
                validator: (c) =>
                    c == null ? 'Customer phone number is required' : null,
              ),
            ),
            _labeledText(
              'Email Address',
              Text(_selectedCustomer != null && _selectedCustomer.email != null
                  ? _selectedCustomer.email
                  : '-'),
            ),
            _labeledText(
              'User Type',
              Text(_selectedCustomer != null ? _selectedCustomer.type : '-'),
            ),
            _labeledText(
              'Registered Date',
              Text(_selectedCustomer != null
                  ? _selectedCustomer.datetimeRegisteredString
                  : '-'),
            ),
          ],
        ),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton.icon(
            icon: Icon(Icons.add),
            label: Text('New Customer'),
            style: ButtonStyle(padding: MaterialStateProperty.all(PADDING16)),
            onPressed: () => showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => AddCustomerDialog(),
            ),
          ),
        ),
        Divider(color: Colors.indigo),
      ],
    );
  }

  Widget _carPanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: PADDING16,
          child: Text(
            'Select Car',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Wrap(
          children: [
            _labeledText(
              'Car ID',
              DropdownSearch<Car>(
                mode: Mode.MENU,
                showSearchBox: true,
                hint: _selectedCustomer != null
                    ? '-- Select --'
                    : 'Please select customer first',
                selectedItem: _selectedCar,
                items: _cars,
                enabled: _selectedCustomer != null,
                itemAsString: (c) => c.id.toString(),
                filterFn: (c, filter) => c.id.toString().contains(filter),
                onChanged: (c) => setState(() => _selectedCar = c),
                validator: (c) => c == null ? 'Car ID is required' : null,
              ),
            ),
            _labeledText(
              'Plate Number',
              DropdownSearch<Car>(
                mode: Mode.MENU,
                showSearchBox: true,
                hint: _selectedCustomer != null
                    ? '-- Select --'
                    : 'Please select customer first',
                selectedItem: _selectedCar,
                items: _cars,
                enabled: _selectedCustomer != null,
                itemAsString: (c) => c.plateNo,
                filterFn: (c, filter) =>
                    c.plateNo.contains(filter.toUpperCase()),
                onChanged: (c) => setState(() => _selectedCar = c),
                validator: (c) =>
                    c == null ? 'Car plate number is required' : null,
              ),
            ),
            _labeledText(
              'Model',
              Text(_selectedCar != null ? _selectedCar.carModel.name : '-'),
            ),
            _labeledText(
              'Last Serviced Date',
              Text(_selectedCar != null && _selectedCar.dateFromService != null
                  ? _selectedCar.dateFromServiceString
                  : '-'),
            ),
          ],
        ),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton.icon(
            icon: Icon(Icons.add),
            label: Text('New Car'),
            style: ButtonStyle(padding: MaterialStateProperty.all(PADDING16)),
            onPressed: _selectedCustomer != null
                ? () => showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => AddCarDialog(_selectedCustomer),
                    )
                : null,
          ),
        ),
        Divider(color: Colors.indigo),
      ],
    );
  }

  Widget _branchPanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: PADDING16,
          child: Text(
            'Select Branch',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Wrap(
          children: [
            _labeledText(
              'Branch ID',
              DropdownSearch<Branch>(
                mode: Mode.MENU,
                showSearchBox: true,
                hint: '-- Select --',
                selectedItem: _selectedBranch,
                items: _branches,
                itemAsString: (b) => b.id.toString(),
                filterFn: (b, filter) => b.id.toString().contains(filter),
                onChanged: _onBranchSelected,
                validator: (b) => b == null ? 'Branch ID is required' : null,
              ),
            ),
            _labeledText(
              'Email Address',
              DropdownSearch<Branch>(
                mode: Mode.MENU,
                showSearchBox: true,
                hint: '-- Select --',
                selectedItem: _selectedBranch,
                items: _branches,
                itemAsString: (b) => b.email,
                filterFn: (b, filter) =>
                    b.email.toLowerCase().contains(filter.toLowerCase()),
                onChanged: _onBranchSelected,
                validator: (b) => b == null ? 'Branch email is required' : null,
              ),
            ),
            _labeledText(
              'Name',
              DropdownSearch<Branch>(
                mode: Mode.MENU,
                showSearchBox: true,
                hint: '-- Select --',
                selectedItem: _selectedBranch,
                items: _branches,
                itemAsString: (b) => b.name,
                filterFn: (b, filter) =>
                    b.name.toLowerCase().contains(filter.toLowerCase()),
                onChanged: _onBranchSelected,
                validator: (b) => b == null ? 'Branch name is required' : null,
              ),
            ),
            _labeledText(
              'Location',
              DropdownSearch<Branch>(
                mode: Mode.DIALOG,
                showSearchBox: true,
                hint: '-- Select --',
                selectedItem: _selectedBranch,
                items: _branches,
                itemAsString: (b) => b.location,
                filterFn: (b, filter) =>
                    b.location.toLowerCase().contains(filter.toLowerCase()),
                onChanged: _onBranchSelected,
                validator: (b) =>
                    b == null ? 'Branch location is required' : null,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Divider(color: Colors.indigo),
      ],
    );
  }

  Widget _servicePanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: PADDING16,
          child: Text(
            'Select Service',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Wrap(
          children: [
            _labeledText(
              'Service ID',
              DropdownSearch<Service>(
                mode: Mode.MENU,
                showSearchBox: true,
                hint: '-- Select --',
                selectedItem: _selectedService,
                items: _services,
                itemAsString: (s) => s.id.toString(),
                filterFn: (s, filter) => s.id.toString().contains(filter),
                onChanged: (s) => setState(() => _selectedService = s),
                validator: (s) => s == null ? 'Service ID is required' : null,
              ),
            ),
            _labeledText(
              'Name',
              DropdownSearch<Service>(
                mode: Mode.MENU,
                showSearchBox: true,
                hint: '-- Select --',
                selectedItem: _selectedService,
                items: _services,
                itemAsString: (s) => s.name,
                filterFn: (s, filter) =>
                    s.name.toLowerCase().contains(filter.toLowerCase()),
                onChanged: (s) => setState(() => _selectedService = s),
                validator: (s) => s == null ? 'Service name is required' : null,
              ),
            ),
            _labeledText(
              'Duration',
              Text(_selectedService != null
                  ? _selectedService.durationString
                  : '-'),
            ),
            _labeledText(
              'Fee',
              Text(_selectedService != null ? _selectedService.feeString : '-'),
            ),
          ],
        ),
        SizedBox(height: 16),
        Divider(color: Colors.indigo),
      ],
    );
  }

  Widget _dateTimePanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: PADDING16,
          child: Text(
            'Select Date',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Wrap(
          children: [
            _labeledText(
              'Date to Service',
              TextField(
                readOnly: true,
                mouseCursor: MaterialStateMouseCursor.clickable,
                controller: _dateController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.black,
                  ),
                  hintText: '-- Select --',
                  errorText: !_isDateValid ? 'Date is required' : null,
                ),
                onTap: () async {
                  final tomorrow = DateTime(
                    DateTime.now().year,
                    DateTime.now().month,
                    DateTime.now().day + 1,
                  );
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate ?? tomorrow,
                    firstDate: tomorrow,
                    lastDate: DateTime(
                      tomorrow.year + 1,
                      tomorrow.month,
                      tomorrow.day - 1,
                    ),
                  );
                  if (selectedDate != null) {
                    _selectedDate = selectedDate;
                    _dateController.text =
                        cass.DateUtils.fromDate(_selectedDate);
                  }
                },
              ),
            ),
            _labeledText(
              'Time to Service',
              DropdownSearch<TimeOfDay>(
                mode: Mode.MENU,
                enabled: _selectedService != null,
                dropDownButton: Icon(Icons.schedule),
                hint: _selectedService != null
                    ? '-- Select --'
                    : 'Please select service first',
                selectedItem: _selectedTime,
                items: _getTimes(),
                itemAsString: (t) {
                  final start = DateTime(DateTime.now().year).add(
                    Duration(hours: t.hour, minutes: t.minute),
                  );
                  final end = start.add(
                    Duration(
                        minutes: _selectedService != null
                            ? _selectedService.duration
                            : 0),
                  );
                  return '${cass.DateUtils.fromTime(start)}  -  ${cass.DateUtils.fromTime(end)}';
                },
                onChanged: (t) => setState(() => _selectedTime = t),
                validator: (t) => t == null ? 'Time is required' : null,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Divider(color: Colors.indigo),
      ],
    );
  }

  Widget _remarkPanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: PADDING16,
          child: Text(
            'Remark',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          padding: PADDING16,
          child: TextFormField(
            controller: _remarkController,
            minLines: 5,
            maxLines: 10,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Leave some remark about this service',
            ),
          ),
        ),
      ],
    );
  }
}
