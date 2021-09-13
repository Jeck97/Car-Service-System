import 'package:cass_branch/api/customer_api.dart';
import 'package:cass_branch/model/customer.dart';
import 'package:cass_branch/utils/dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'customer_data_table_source.dart';
import 'customer_detail_page.dart';
import 'customer_table.dart';

class CustomerMainPage extends StatefulWidget {
  static const String ROUTE = 'customer_main_page/';

  @override
  _CustomerMainPageState createState() => _CustomerMainPageState();
}

class _CustomerMainPageState extends State<CustomerMainPage> {
  List<Customer> _customers = [];
  bool _isLoading = false;
  final _searchController = TextEditingController();

  void _fetchCustomers() async {
    setState(() => _isLoading = true);
    final response =
        await CustomerAPI.fetch(search: _searchController.text.trim());
    setState(() {
      if (response.isSuccess) {
        _customers = response.data;
        if (_customers.isEmpty)
          DialogUtils.show(
            context,
            'Result ${_searchController.text.trim()} not found.',
          );
      } else
        DialogUtils.show(context, response.message);
      _isLoading = false;
    });
  }

  void _customerClick(Customer customer) => Navigator.of(context)
      .pushNamed(CustomerDetailPage.ROUTE, arguments: customer);

  @override
  void initState() {
    _fetchCustomers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Customer',
            style: Theme.of(context)
                .textTheme
                .headline5
                .copyWith(color: Colors.white),
          ),
        ),
        body: Container(
          width: double.maxFinite,
          child: CustomerTable(
            customerTableSource: CustomerDataTableSource(
              customers: _customers,
              onRowClick: _customerClick,
            ),
            controller: _searchController,
            onFetched: _fetchCustomers,
          ),
        ),
      ),
    );
  }
}
