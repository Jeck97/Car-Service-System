import 'package:flutter/material.dart';

import 'dashboard_aside.dart';
import 'dashboard_content.dart';

class DashboardPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade100,
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: Theme.of(context)
              .textTheme
              .headline5
              .copyWith(color: Colors.white),
        ),
      ),
      body: Row(
        children: <Widget>[
          DashboardContent(),
          DashboardAside(),
        ],
      ),
    );
  }
}
