import 'package:flutter/material.dart';

import 'dashboard_content_graph.dart';
import 'dashboard_content_overview.dart';

class DashboardContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            DashboardContentOverview(),
            DashboardContentGraph(),
          ],
        ),
      ),
    );
  }
}
