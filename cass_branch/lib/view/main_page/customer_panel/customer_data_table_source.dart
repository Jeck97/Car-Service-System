import 'package:cass_branch/model/customer.dart';
import 'package:flutter/material.dart';

class CustomerDataTableSource extends DataTableSource {
  final List<Customer> customers;
  final void Function(Customer customer) onRowClick;
  CustomerDataTableSource({
    @required this.customers,
    @required this.onRowClick,
  });

  @override
  DataRow getRow(int index) {
    if (customers == null) return null;
    Customer customer = customers[index];
    return DataRow.byIndex(
      index: index,
      onSelectChanged: (_) => onRowClick(customer),
      cells: <DataCell>[
        DataCell(Text('${customer.id}')),
        DataCell(Text(customer.name)),
        DataCell(Text(customer.phoneNo)),
        DataCell(Text(customer.email != null ? customer.email : '-')),
        DataCell(
          customer.type == Customer.TYPE.appUser
              ? Icon(Icons.check, color: Colors.green)
              : Icon(Icons.close, color: Colors.red),
        ),
        DataCell(Text(customer.datetimeRegisteredString)),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => customers.length;

  @override
  int get selectedRowCount => 0;
}
