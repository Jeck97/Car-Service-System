import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SettingPanel extends StatefulWidget {
  @override
  _ReportPanelState createState() => _ReportPanelState();
}

class _ReportPanelState extends State<SettingPanel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Setting')),
      body: Container(
        width: 200,
        child: LineChart(
          LineChartData(borderData: FlBorderData(show: false), lineBarsData: [
            LineChartBarData(spots: [
              FlSpot(0, 1),
              FlSpot(1, 3),
              FlSpot(2, 10),
              FlSpot(3, 7),
              FlSpot(4, 12),
              FlSpot(5, 13),
              FlSpot(6, 17),
              FlSpot(7, 15),
              FlSpot(8, 20)
            ])
          ]),
        ),
      ),
    );
  }
}
