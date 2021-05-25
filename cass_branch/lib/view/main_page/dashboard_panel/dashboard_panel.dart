import 'package:flutter/material.dart';

class DashboardPanel extends StatefulWidget {
  @override
  _DashboardPanelState createState() => _DashboardPanelState();
}

class _DashboardPanelState extends State<DashboardPanel> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) => MaterialPageRoute(
        builder: (context) => settings.name == 'r2'
            ? Scaffold(
                appBar: AppBar(
                  title: GestureDetector(
                    child: Text('Route 2'),
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ),
              )
            : Scaffold(
                appBar: AppBar(
                  title: Text('Route 1'),
                ),
                body: Scaffold(
                  appBar: AppBar(
                    title: GestureDetector(
                      child: Text('Dashboard'),
                      onTap: () {
                        Navigator.of(context).pushNamed('r2');
                      },
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
