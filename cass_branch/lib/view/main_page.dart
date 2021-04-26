import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'booking_panel.dart';
import 'customer_panel.dart';
import 'dashboard_panel.dart';
import 'navigation_bar.dart';
import 'payment_panel.dart';
import 'report_panel.dart';
import 'service_panel.dart';
import 'setting_panel.dart';

final List<Widget> panels = [];
int currentIndex;

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  void updateIndex(int index) => setState(() => currentIndex = index);

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
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        bool isCollapsed = sizingInformation.screenSize.width < 1000;
        return Scaffold(
          body: Row(
            children: <Widget>[
              NavigationBar(isCollapsed, currentIndex, updateIndex),
              Expanded(
                child: IndexedStack(index: currentIndex, children: panels),
              ),
            ],
          ),
        );
      },
    );
  }
}
