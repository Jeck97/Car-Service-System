import 'package:flutter/material.dart';

class ReportPanel extends StatefulWidget {
  @override
  _ReportPanelState createState() => _ReportPanelState();
}

class _ReportPanelState extends State<ReportPanel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Report')),
      body: TextField(),
    );
  }
}
