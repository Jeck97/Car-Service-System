import 'dart:convert';

import 'package:cass_branch/model/customer.dart';
import 'package:cass_branch/utils/const.dart';
import 'package:cass_branch/utils/dummy.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';

class CustomerPanel extends StatefulWidget {
  @override
  _CustomerPanelState createState() => _CustomerPanelState();
}

class _CustomerPanelState extends State<CustomerPanel> {
  List<Customer> _customers;
  bool _isLoading;
  bool _isAscending;
  int _currentSortColumn;

  void onSortId(int columnIndex, bool ascending) {
    setState(() {
      _currentSortColumn = columnIndex;
      _isAscending = ascending;
      ascending
          ? _customers.sort((a, b) => a.id.compareTo(b.id))
          : _customers.sort((a, b) => b.id.compareTo(a.id));
    });
  }

  void _showDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _getCustomers(Function callback) async {
    setState(() => _isLoading = true);
    http.get(Uri.http(AUTHORITY, 'api/customers'), headers: HEADERS).then(
        (response) {
      var resBody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        List<Map> customers = List.from(resBody[DATA]);
        callback(
            customers
                .map((customerJson) => Customer.fromJson(customerJson))
                .toList(),
            null);
      } else
        callback(null, resBody[MESSAGE]);
    }, onError: (error) => callback(null, SERVER_ERROR));
  }

  @override
  void initState() {
    _currentSortColumn = 0;
    _isAscending = true;
    _getCustomers((customers, errMessage) => setState(() {
          customers != null ? _customers = customers : _showDialog(errMessage);
          _isLoading = false;
        }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: GestureDetector(
            child: Text(NAV_TITLES[CUSTOMER]),
            onTap: () => Dummy.generateCustomers(10, _showDialog),
          ),
        ),
        body: SingleChildScrollView(
            child: _CustomerTable(
          customers: _customers,
          sortColumnIndex: _currentSortColumn,
          sortAscending: _isAscending,
          onSortId: onSortId,
        )),
      ),
    );
  }
}

class _CustomerTable extends StatelessWidget {
  final List<Customer> customers;
  final int sortColumnIndex;
  final bool sortAscending;
  final Function onSortId;
  _CustomerTable(
      {this.customers,
      this.sortColumnIndex,
      this.sortAscending,
      this.onSortId});

  @override
  Widget build(BuildContext context) {
    return DataTable(
      sortColumnIndex: sortColumnIndex,
      sortAscending: sortAscending,
      headingRowColor: MaterialStateProperty.all(Colors.blueAccent),
      columns: <DataColumn>[
        DataColumn(
          label: Text(
            'ID',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          numeric: true,
          onSort: onSortId,
        ),
        DataColumn(
          label: Text(
            'Name',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        DataColumn(
          label: Text(
            'Phone No.',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        DataColumn(
          label: Text(
            'Email',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        DataColumn(
          label: Text(
            'Created Date',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onSort: onSortId,
        ),
      ],
      rows: customers != null
          ? customers.map((customer) {
              return DataRow(
                cells: <DataCell>[
                  DataCell(Text(customer.id.toString())),
                  DataCell(Text(customer.name)),
                  DataCell(Text(customer.phoneNo)),
                  DataCell(Text(customer.email != null ? customer.email : '-')),
                  DataCell(
                      Text(customer.dateCreated.toString().substring(0, 10))),
                ],
              );
            }).toList()
          : [],
    );
  }
}
