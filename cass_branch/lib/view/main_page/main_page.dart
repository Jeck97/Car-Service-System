import 'package:flutter/material.dart';

import 'booking_panel/booking_panel.dart';
import 'dashboard_panel/dashboard_panel.dart';
import 'customer_panel/customer_panel.dart';
import 'navigation_bar.dart';
import 'payment_panel/payment_panel.dart';
import 'report_panel/report_panel.dart';
import 'service_panel/service_panel.dart';
import 'setting_panel/setting_panel.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<Widget> panels = [];
  int currentIndex;

  void onIndexUpdate(int index) => setState(() => currentIndex = index);

  @override
  void initState() {
    currentIndex = 0;
    panels
      ..add(DashboardPanel())
      ..add(BookingPanel())
      ..add(ServicePanel())
      ..add(CustomerPanel())
      ..add(PaymentPanel())
      ..add(ReportPanel())
      ..add(SettingPanel());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: NavigationBar(
                currentIndex: currentIndex,
                onIndexUpdate: onIndexUpdate,
              ),
            ),
            Expanded(
              flex: 5,
              child: IndexedStack(
                index: currentIndex,
                children: panels,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
