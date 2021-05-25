import 'dart:math';

import 'package:cass_branch/utils/constants.dart';
import 'package:flutter/material.dart';

class LoginBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: <Color>[
            Colors.lightBlue.shade200,
            Colors.indigoAccent,
            Colors.purpleAccent.shade200,
          ],
        ),
      ),
      child: Stack(
        children: <Widget>[
          _positionedRectangle(
            top: -100,
            left: -150,
            width: 400,
            height: 600,
            angle: pi / 4,
          ),
          _positionedRectangle(
            right: -250,
            bottom: -150,
            width: 500,
            height: 800,
            angle: -pi / 6,
          ),
        ],
      ),
    );
  }

  Widget _positionedRectangle({
    double left,
    double top,
    double right,
    double bottom,
    double angle = pi / 4,
    double width = 600.0,
    double height = 600.0,
  }) {
    return Positioned(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      child: Transform.rotate(
        angle: angle,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BORDER_RADIUS24,
            color: Colors.grey.shade100.withOpacity(0.1),
          ),
        ),
      ),
    );
  }
}
