import 'package:cass_branch/model/customer.dart';
import 'package:flutter/material.dart';

import 'components/customer_detail_page.dart';
import 'components/customer_main_page.dart';

class CustomerPanel extends StatefulWidget {
  @override
  _CustomerPanelState createState() => _CustomerPanelState();
}

class _CustomerPanelState extends State<CustomerPanel> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: CustomerMainPage.ROUTE,
      onGenerateRoute: (settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case CustomerMainPage.ROUTE:
            builder = (_) => CustomerMainPage();
            break;
          case CustomerDetailPage.ROUTE:
            Customer customer = settings.arguments as Customer;
            builder = (_) => CustomerDetailPage(customer);
            break;
          default:
            throw Exception('Invalid route: ${settings.name}');
        }
        return MaterialPageRoute(builder: builder, settings: settings);
      },
    );
  }
}
