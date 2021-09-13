import 'package:cass_branch/api/service_api.dart';
import 'package:cass_branch/model/branch.dart';
import 'package:cass_branch/model/service.dart';
import 'package:cass_branch/utils/constants.dart';
import 'package:cass_branch/utils/dialog_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class DashboardAside extends StatefulWidget {
  @override
  State<DashboardAside> createState() => _DashboardAsideState();
}

class _DashboardAsideState extends State<DashboardAside> {
  List<Service> _services;

  int _totalCount;

  void _fetchServices() async {
    final response = await ServiceAPI.fetchReserved(Branch.instance);
    if (response.isSuccess) {
      setState(() {
        _services = response.data;
        _services.sort((a, b) => b.count.compareTo(a.count));
        _totalCount = _services.fold<int>(0, (i, s) => i + s.count);
      });
    } else
      DialogUtils.show(context, response.message);
  }

  @override
  void initState() {
    _fetchServices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: double.infinity,
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
      child: _services == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.equalizer_rounded,
                        size: 36,
                        color: Colors.indigo,
                      ),
                      SizedBox(width: 12),
                      Text(
                        "SERVICE RANKING",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  Column(
                    children: List.generate(
                      _services.length,
                      (index) => _rankingTile(index),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _rankingTile(int index) {
    Color color;
    switch (index) {
      case 0:
        color = Colors.redAccent;
        break;
      case 1:
        color = Colors.orangeAccent;
        break;
      case 2:
        color = Colors.yellowAccent;
        break;
      default:
        color = Colors.blueGrey.shade100;
    }
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: color,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.grey.shade400,
            offset: const Offset(2.0, 2.0),
            blurRadius: 2.0,
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 16,
          backgroundColor: Colors.white,
          child: Text(
            "${index + 1}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
              shadows: <Shadow>[
                Shadow(
                  offset: Offset(-1.5, -1.5),
                  color: Colors.black,
                ),
                Shadow(
                  offset: Offset(1.5, -1.5),
                  color: Colors.black,
                ),
                Shadow(
                  offset: Offset(1.5, 1.5),
                  color: Colors.black,
                ),
                Shadow(
                  offset: Offset(-1.5, 1.5),
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ),
        title: Text(
          _services[index].name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Text(
          "${_services[index].count * 100 ~/ _totalCount}%",
          textAlign: TextAlign.end,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
