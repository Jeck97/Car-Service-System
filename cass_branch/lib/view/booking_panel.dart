import 'package:cass_branch/utils/const.dart';
import 'package:flutter/material.dart';

class BookingPanel extends StatefulWidget {
  @override
  _BookingPanelState createState() => _BookingPanelState();
}

class _BookingPanelState extends State<BookingPanel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(NAV_TITLES[BOOKING])),
      body: TextField(),
    );
  }
}
