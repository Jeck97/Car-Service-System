import 'package:cass_branch/utils/const.dart';

import 'package:flutter/material.dart';

class DashboardPanel extends StatefulWidget {
  @override
  _DashboardPanelState createState() => _DashboardPanelState();
}

class _DashboardPanelState extends State<DashboardPanel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          child: Text(NAV_TITLES[DASHBOARD]),
        ),
      ),
    );
  }
}
