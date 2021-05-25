import 'package:cass_branch/model/customer.dart';
import 'package:flutter/material.dart';

import 'add_car_dialog.dart';
import 'customer_detail_information_panel.dart';
import 'customer_detail_reservation_panel.dart';

class CustomerDetailPage extends StatelessWidget {
  static const ROUTE = 'customer_detail_page/';
  final Customer _customer;

  CustomerDetailPage(this._customer);

  @override
  Widget build(BuildContext context) {
    final customerReservationPanel = CustomerDetailReservationPanel(_customer);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Customer Detail',
          style: Theme.of(context)
              .textTheme
              .headline5
              .copyWith(color: Colors.white),
        ),
        actions: _appBarActions(
          onAddCar: () => showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => AddCarDialog(_customer),
          ),
          onRefresh: customerReservationPanel.refresh,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CustomerDetailInformationPanel(_customer),
          customerReservationPanel,
        ],
      ),
    );
  }

  List<Widget> _appBarActions({
    @required void Function() onAddCar,
    @required void Function() onRefresh,
  }) {
    return <Widget>[
      IconButton(
        onPressed: () {},
        tooltip: 'Make reservation',
        icon: Icon(Icons.today_outlined),
      ),
      IconButton(
        onPressed: onAddCar,
        tooltip: 'Add new car',
        icon: Icon(Icons.add),
      ),
      IconButton(
        onPressed: onRefresh,
        tooltip: 'Refresh',
        icon: Icon(Icons.refresh),
      ),
    ];
  }
}
