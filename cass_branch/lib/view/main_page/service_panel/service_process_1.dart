import 'package:cass_branch/utils/constants.dart';
import 'package:flutter/material.dart';

class ServiceProcess1 extends StatefulWidget {
  final VoidCallback onStepNext;
  ServiceProcess1({@required this.onStepNext});

  @override
  State<ServiceProcess1> createState() => _ServiceProcess1State();
}

class _ServiceProcess1State extends State<ServiceProcess1>
    with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    )
      ..addListener(() => setState(() {}))
      ..repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: PADDING32,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Text(
              "Waiting for customer response...",
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          LinearProgressIndicator(value: _controller.value),
          SizedBox(height: 48),
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              child: Icon(Icons.rate_review),
              tooltip: "Help Customer to Response",
              onPressed: widget.onStepNext,
            ),
          ),
        ],
      ),
    );
  }
}
