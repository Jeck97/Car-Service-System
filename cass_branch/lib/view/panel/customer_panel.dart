import 'package:cass_branch/utils/const.dart';
import 'package:flutter/material.dart';

class CustomerPanel extends StatefulWidget {
  @override
  _CustomerPanelState createState() => _CustomerPanelState();
}

class _CustomerPanelState extends State<CustomerPanel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(NAV_TITLES[CUSTOMER])),
      body: TextField(),
    );
  }
}
