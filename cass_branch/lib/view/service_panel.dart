import 'package:cass_branch/utils/const.dart';
import 'package:flutter/material.dart';

class ServicePanel extends StatefulWidget {
  @override
  _ServicePanelState createState() => _ServicePanelState();
}

class _ServicePanelState extends State<ServicePanel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(NAV_TITLES[SERVICE])),
      body: TextField(),
    );
  }
}
