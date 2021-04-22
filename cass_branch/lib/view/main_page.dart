import 'package:cass_branch/model/branch.dart';
import 'package:cass_branch/utils/const.dart';
import 'package:cass_branch/view/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

final List<Widget> panels =
    List.filled(NAV_ICONS.length, null, growable: false);

class MainPage extends StatelessWidget {
  final Branch branch;

  MainPage(this.branch);

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        bool isCollapsed = sizingInformation.screenSize.width < 1000;
        return Scaffold(
          body: Row(
            children: <Widget>[
              NavigationBar(isCollapsed),
              DashboardPage(branch),
            ],
          ),
        );
      },
    );
  }
}

class DashboardPage extends StatelessWidget {
  final Branch branch;
  DashboardPage(this.branch);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Dashboard'),
          backgroundColor: Colors.purple,
        ),
        body: Column(
          children: <Widget>[
            Text('${branch.id}'),
            Text(branch.name),
            Text(branch.email),
            Text(branch.location),
          ],
        ),
      ),
    );
  }
}
