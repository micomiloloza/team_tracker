import 'package:flutter/material.dart';

class RadialProgress extends StatefulWidget {
  @override
  _RadialProgressState createState() => _RadialProgressState();
}

class _RadialProgressState extends State<RadialProgress> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      child: Container(
        height: 200,
        width: 200
      ),
    );
  }
}