import 'package:cass_branch/utils/const.dart';
import 'package:flutter/material.dart';

class PaymentPanel extends StatefulWidget {
  @override
  _PaymentPanelState createState() => _PaymentPanelState();
}

class _PaymentPanelState extends State<PaymentPanel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(NAV_TITLES[PAYMENT])),
      body: TextField(),
    );
  }
}
