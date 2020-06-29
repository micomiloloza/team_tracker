import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:team_tracker/ui/components/graphs/middle_ring.dart';
import 'package:team_tracker/ui/components/graphs/progress_rings.dart';

class NeumorphicPie extends StatefulWidget {
  final double width;
  final double height;
  final double value;
  final bool reverseColors;

  NeumorphicPie(this.width, this.height, this.value, this.reverseColors);
  
  @override
  _NeumorphicPieState createState() => _NeumorphicPieState();
}

class _NeumorphicPieState extends State<NeumorphicPie> with SingleTickerProviderStateMixin {

  AnimationController _animationController;
  Animation _progressAnimation;

  double progressDegrees = 0.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    _progressAnimation = Tween(begin: 0.0, end: 360.0).animate(_animationController)..addListener(() {
      setState(() {
        progressDegrees = widget.value * _animationController.value;
      });
    });

    _animationController.forward();
  }
  
  @override
  Widget build(BuildContext context) {
    // Outer white circle
    return Container(
      height: widget.width,
      width: widget.height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white24,
      ),
      child: Center(
        // Container of the pie chart
        child: Container(
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                spreadRadius: 6,
                blurRadius: 10,
                offset: Offset(0, 4), // changes position of shadow
              ),
            ],
          ),
          child: Stack(
            children: <Widget>[
              Center(child: MiddleRing(width: widget.width + 50, value: widget.value)),
              Transform.rotate(
                angle: -pi / 2,
                child: CustomPaint(
                  child: Center(),
                  painter: ProgressRings(
                    completedPercentage: progressDegrees / 10,//widget.value / 10,
                    circleWidth: 15.0,
                    gradient: widget.reverseColors ? redToGreenGradient : greenToRedGradient,
                    gradientStartAngle: -pi / 6,
                    gradientEndAngle: 2 * pi,
                    progressStartAngle: pi / 1.80
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final innerColor = Color.fromRGBO(233, 242, 249, 1);
final shadowColor = Color.fromRGBO(220, 227, 234, 1);

const greenToRedGradient = [
  Color.fromRGBO(129, 250, 112, 1),
  Color.fromRGBO(255, 93, 91, 1)
];

const redToGreenGradient = [
  Color.fromRGBO(255, 93, 91, 1),
  Color.fromRGBO(129, 250, 112, 1)
];
const greenGradient = [
  Color.fromRGBO(223, 250, 92, 1),
  Color.fromRGBO(129, 250, 112, 1)
];
const turqoiseGradient = [
  Color.fromRGBO(91, 253, 199, 1),
  Color.fromRGBO(129, 182, 205, 1)
];

const redGradient = [
  Color.fromRGBO(255, 93, 91, 1),
  Color.fromRGBO(254, 154, 92, 1),
];
const orangeGradient = [
  Color.fromRGBO(251, 173, 86, 1),
  Color.fromRGBO(253, 255, 93, 1),
];