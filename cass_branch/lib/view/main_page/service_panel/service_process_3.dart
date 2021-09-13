import 'package:cass_branch/api/service_api.dart';
import 'package:cass_branch/model/action.dart' as a;
import 'package:cass_branch/model/reservation.dart';
import 'package:cass_branch/utils/constants.dart';
import 'package:cass_branch/utils/dialog_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ServiceProcess3 extends StatefulWidget {
  final Reservation reservation;
  final VoidCallback onStepNext;

  ServiceProcess3({
    @required this.reservation,
    @required this.onStepNext,
  });
  @override
  State<ServiceProcess3> createState() => _ServiceProcess3State();
}

class _ServiceProcess3State extends State<ServiceProcess3> {
  final List<String> _labels = ["NO.", "ACTION", "FEE (RM)"];
  List<a.Action> _actions;

  void _fetchActions() async {
    final response = await ServiceAPI.fetchActions(
      widget.reservation.service,
      actions: widget.reservation.servicing.acceptedActions.join(","),
    );
    response.isSuccess
        ? setState(() => _actions = response.data)
        : DialogUtils.show(context, response.message);
  }

  @override
  void initState() {
    _fetchActions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_actions == null) return Container();
    return Container(
      padding: PADDING32,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          DataTable(
            showBottomBorder: true,
            headingTextStyle: TextStyle(
              color: Colors.blueGrey,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            columns: List.generate(
              _labels.length,
              (index) => DataColumn(label: Text(_labels[index])),
            ),
            rows: List.generate(_actions.length, (index) {
              return DataRow(
                cells: <DataCell>[
                  DataCell(Text("${index + 1}")),
                  DataCell(
                    Container(
                      child: Text(_actions[index].description),
                      width: MediaQuery.of(context).size.width - 950,
                    ),
                  ),
                  DataCell(Text(_actions[index].priceString)),
                ],
              );
            }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  "TOTAL FEE",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  "RM " +
                      _actions
                          .fold<double>(0, (i, a) => i + a.price)
                          .toStringAsFixed(2),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: Text("PAY", style: TextStyle(fontSize: 16)),
                ),
                onPressed: widget.onStepNext,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
