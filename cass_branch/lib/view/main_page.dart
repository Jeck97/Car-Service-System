import 'package:cass_branch/view/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'panel/booking_panel.dart';
import 'panel/customer_panel.dart';
import 'panel/dashboard_panel.dart';
import 'panel/payment_panel.dart';
import 'panel/report_panel.dart';
import 'panel/service_panel.dart';
import 'panel/setting_panel.dart';

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
