import 'package:cass_branch/utils/const.dart';
import 'package:flutter/material.dart';

class DashboardPanel extends StatefulWidget {
  @override
  _DashboardPanelState createState() => _DashboardPanelState();
}

enum BestTutorSite { javatpoint, w3schools, tutorialandexample }

class _DashboardPanelState extends State<DashboardPanel> {
  BestTutorSite _site = BestTutorSite.javatpoint;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(NAV_TITLES[DASHBOARD])),
        body: Column(
          children: <Widget>[
            ListTile(
              title: const Text('www.javatpoint.com'),
              leading: Radio(
                value: BestTutorSite.javatpoint,
                groupValue: _site,
                onChanged: (BestTutorSite value) {
                  setState(() {
                    _site = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('www.w3school.com'),
              leading: Radio(
                value: BestTutorSite.w3schools,
                groupValue: _site,
                onChanged: (BestTutorSite value) {
                  setState(() {
                    _site = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('www.tutorialandexample.com'),
              leading: Radio(
                value: BestTutorSite.tutorialandexample,
                groupValue: _site,
                onChanged: (BestTutorSite value) {
                  setState(() {
                    _site = value;
                  });
                },
              ),
            ),
          ],
        ));
  }
}
