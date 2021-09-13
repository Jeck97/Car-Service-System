import 'dart:math';

import 'package:cass_branch/api/reservation_api.dart';
import 'package:cass_branch/model/branch.dart';
import 'package:cass_branch/model/statistic.dart';
import 'package:cass_branch/utils/constants.dart';
import 'package:cass_branch/utils/dialog_utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DashboardContentGraph extends StatefulWidget {
  @override
  State<DashboardContentGraph> createState() => _DashboardContentGraphState();
}

class _DashboardContentGraphState extends State<DashboardContentGraph> {
  List<Statistic> _statistics;
  List<Statistic> _filteredStatistic;
  List<int> _years;
  int _selectedYear;

  void _fetchStatistics() async {
    final response = await ReservationAPI.fetchStatistics(Branch.instance);
    if (response.isSuccess) {
      setState(() {
        _statistics = response.data;
        _filteredStatistic =
            _statistics.where((s) => s.date.year == _selectedYear).toList();
        _years = _statistics.map((s) => s.date.year).toSet().toList();
      });
    } else
      DialogUtils.show(context, response.message);
  }

  void _onYearSelected(int year) {
    setState(() {
      _selectedYear = year;
      _filteredStatistic =
          _statistics.where((s) => s.date.year == _selectedYear).toList();
    });
  }

  @override
  void initState() {
    _selectedYear = DateTime.now().year;
    _fetchStatistics();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: PADDING24,
      margin: PADDING24,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BORDER_RADIUS08,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.grey,
            offset: const Offset(2.0, 2.0),
            blurRadius: 2.0,
          ),
        ],
      ),
      child: _statistics == null
          ? Container(
              height: 580,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.insert_chart_outlined_rounded,
                          size: 36,
                          color: Colors.indigo,
                        ),
                        SizedBox(width: 12),
                        Text(
                          "RESERVATION STATISTIC",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                          ),
                        ),
                      ],
                    ),
                    DropdownButton<int>(
                      underline: Container(height: 2, color: Colors.indigo),
                      icon: Icon(Icons.arrow_drop_down, color: Colors.indigo),
                      iconEnabledColor: Colors.indigo,
                      iconSize: 36,
                      style: TextStyle(
                        color: Colors.indigo,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                      value: _selectedYear,
                      items: _years
                          .map((y) =>
                              DropdownMenuItem(child: Text("$y"), value: y))
                          .toList(),
                      onChanged: _onYearSelected,
                    ),
                  ],
                ),
                SizedBox(height: 36),
                SizedBox(
                  width: 800,
                  height: 580,
                  child: _LineChartWidget(_filteredStatistic),
                ),
              ],
            ),
    );
  }
}

class _LineChartWidget extends StatelessWidget {
  final List<Statistic> statistics;

  _LineChartWidget(this.statistics);

  String _getMonth(double month) {
    switch (month.toInt()) {
      case 1:
        return "JAN";
      case 2:
        return "FEB";
      case 3:
        return "MAR";
      case 4:
        return "APL";
      case 5:
        return "MAY";
      case 6:
        return "JUN";
      case 7:
        return "JUL";
      case 8:
        return "AUG";
      case 9:
        return "SEP";
      case 10:
        return "OCT";
      case 11:
        return "NOV";
      case 12:
        return "DEC";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        minX: 1,
        maxX: 12,
        minY: 0,
        maxY: (statistics.map((s) => s.count).reduce(max)).toDouble(),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: SideTitles(
            showTitles: true,
            reservedSize: 35,
            getTextStyles: (value) => TextStyle(
              color: Colors.blueGrey,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            getTitles: _getMonth,
            margin: 8,
          ),
          leftTitles: SideTitles(
            showTitles: true,
            getTextStyles: (value) => TextStyle(
              color: Colors.blueGrey,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
            getTitles: (value) => value.toStringAsFixed(0),
            reservedSize: 35,
            margin: 12,
          ),
        ),
        gridData: FlGridData(
          show: true,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Colors.blueGrey,
            strokeWidth: 1,
          ),
          drawVerticalLine: true,
          getDrawingVerticalLine: (value) => FlLine(
            color: Colors.blueGrey,
            strokeWidth: 1,
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: statistics
                .map((s) => FlSpot(
                      s.date.month + (s.date.day / s.lastDays),
                      s.count.toDouble(),
                    ))
                .toList(),
            isCurved: true,
            colors: <Color>[
              Colors.blue.shade900,
              Colors.blue.shade300,
            ],
            barWidth: 5,
            belowBarData: BarAreaData(
              show: true,
              colors: <Color>[
                Colors.blue.shade900.withOpacity(0.3),
                Colors.blue.shade300.withOpacity(0.3),
              ],
            ),
          )
        ],
      ),
    );
  }
}
