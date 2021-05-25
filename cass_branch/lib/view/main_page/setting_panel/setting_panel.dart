import 'package:flutter/material.dart';

class SettingPanel extends StatefulWidget {
  @override
  _SettingPanelState createState() => _SettingPanelState();
}

class _SettingPanelState extends State<SettingPanel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Setting')),
      body: TextField(),
    );
  }
}
