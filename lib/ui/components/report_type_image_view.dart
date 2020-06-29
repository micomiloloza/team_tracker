// Copyright 2020 Joshua de Guzman (https://joshuadeguzman.github.io). All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:team_tracker/constants/report_type.dart';
// import 'package:undraw/illustrations.dart';
// import 'package:undraw/undraw.dart';

class ReportTypeImageView extends StatelessWidget {
  final double height;
  final double width;
  final ReportType type;

  const ReportTypeImageView({
    Key key,
    @required this.height,
    @required this.width,
    @required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        height: height,
        width: width,
        child: Center(
          child: Image(image: AssetImage('assets/images/undraw_fitness_stats.png')),
        )
    ),
    // return SizedBox(
    //   height: height,
    //   width: width,
    //   child: Center(
    //     child: Image(image: AssetImage('assets/images/undraw_fitness_stats.png')),
    //   )
      // child: UnDraw(
      //     color: Colors.blue,
      //     illustration: _getIllustration(type),
      //     placeholder: Container(),
      //     errorWidget: Icon(Icons.error_outline, color: Colors.red, size: 50)),
    );
  }

  // UnDrawIllustration _getIllustration(ReportType type) {
  //   switch (type) {
  //     case ReportType.training:
  //       return UnDrawIllustration.personal_trainer;
  //       break;
  //     case ReportType.game:
  //       return UnDrawIllustration.game_day;
  //       break;
  //     case ReportType.coordination:
  //       return UnDrawIllustration.multitasking;
  //       break;
  //     default:
  //       return UnDrawIllustration.not_found;
  //   }
  // }
}
