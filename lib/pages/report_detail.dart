// Copyright 2020 Joshua de Guzman (https://joshuadeguzman.github.io). All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:team_tracker/models/report_model.dart';
import 'package:team_tracker/constants/report_type.dart';
import 'package:team_tracker/pages/report_form.dart';
import 'package:team_tracker/ui/components/graphs/neumorphic_pie.dart';
import 'package:team_tracker/viewmodel/reports_notifier.dart';
import 'package:team_tracker/ui/components/report_type_image_view.dart';
import 'package:provider/provider.dart';
import 'package:team_tracker/services/services.dart';

class ReportDetailScreenArgs {
  final Report report;

  ReportDetailScreenArgs(
    this.report,
  );
}

class ReportDetailScreen extends StatefulWidget {
  static const String routeName = "/report-details";
  // final ReportDetailScreenArgs args;

  // const ReportDetailScreen(this.args);

  @override
  State<StatefulWidget> createState() => _ReportDetailScreenState();
}

class _ReportDetailScreenState extends State<ReportDetailScreen> {
  ReportDetailScreenArgs get _args => ModalRoute.of(context).settings.arguments;//widget.args;
  ReportsNotifier _reportsNotifer;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
  
  Widget build(BuildContext context) {
    _reportsNotifer = Provider.of<ReportsNotifier>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _args.report.title,
          style: Theme.of(context).textTheme.headline5,
        ),
        backgroundColor: themeProvider.isDarkModeOn ? Colors.black12 : Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ReportTypeImageView(
                    height: 150,
                    width: 300,
                    type: EnumToString.fromString(
                      ReportType.values,
                      _args.report.title,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  // HRV MEASURE
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child: Text(
                        "HRV Measure",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(fontSize: 14, color: Colors.grey),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      _args.report.hrvMeasure.toString(),
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(fontSize: 17),
                    ),
                  ),

                  // SMARTPHONE STEPS MEASURE
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 5),
                      child: Text(
                        "Smartphone steps measure",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(fontSize: 14, color: Colors.grey),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      _args.report.stepsMeasure.toString(),
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(fontSize: 17),
                    ),
                  ),

                  // MARK - Internal training load and muscle soreness row
                  buildRowWithGraphAndTitle("Internal training load", "Muscle soreness", _args.report.internalTrainingLoad.toDouble(), _args.report.muscleSoreness.toDouble(), false, false),

                  // MARK - Pain and energy level row
                  buildRowWithGraphAndTitle("Pain", "Energy level", _args.report.pain.toDouble(), _args.report.energyLevel.toDouble(), false, true),

                  // MARK - Mood and Yesterday daily stress row
                  buildRowWithGraphAndTitle("Mood", "Yesterday daily stress", _args.report.mood.toDouble(), _args.report.yesterdayDailyStress.toDouble(), true, false),

                  // MARK - Sleep quality and Sleep quantity row
                  buildRowWithGraphAndTitle("Sleep quality", "Sleep quantity", _args.report.sleepQuality.toDouble(), _args.report.sleepQuantity.toDouble(), true, true),
                  SizedBox(height: 20)
                ],
              ),
            ),
          ],
        ),
      ),
      persistentFooterButtons: <Widget>[
        FlatButton(
          onPressed: () {
            _showDeleteDialog();
          },
          child: Text(
            "Delete",
            style: TextStyle(color: Colors.red),
          ),
        ),
        FlatButton(
          onPressed: () {
            _showEditPage(_args.report);
          },
          child: Text("Edit"),
        ),
      ],
    );
  }

  // Method that creates title and graph row for report data visualization
  Padding buildRowWithGraphAndTitle(String title1, String title2, double value1, double value2, bool graph1ReverseColors, bool graph2ReverseColors) {
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Text(
                  title1,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(fontSize: 12, color: Colors.grey),
                ),
                SizedBox(height: 15),
                NeumorphicPie(100, 100, value1, graph1ReverseColors)
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  title2,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(fontSize: 12, color: Colors.grey),
                ),
                SizedBox(height: 15),
                NeumorphicPie(100, 100, value2, graph2ReverseColors)
              ]
            ),
          )
        ],
      ),
    );
  }

  void _showEditPage(Report report) {
    Navigator.pushNamed(
      context,
      ReportFormScreen.routeName,
      
      arguments: ReportFormScreenArgs(
        reportFormState: ReportFormState.EDIT,
        report: report,
      ),
    );
  }

  void _showDeleteDialog() {
    setState(() {
      showPlatformDialog(
        context: context,
        builder: (_) => BasicDialogAlert(
          title: Text("Confirm deletion"),
          content: Text(
            "This will delete the report \"${_args.report.title}\".\n\nPress \"Confirm\" to continue.",
          ),
          actions: <Widget>[
            BasicDialogAction(
              title: Text(
                "Cancel",
                style: TextStyle(color: Colors.grey),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            BasicDialogAction(
              title: Text(
                "Confirm",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.pop(context);
                _confirmReportDeletion();
              },
            ),
          ],
        ),
      );
    });
  }

  void _confirmReportDeletion() async {
    await _reportsNotifer.deleteReport(_args.report);

    setState(() {
      showPlatformDialog(
        context: context,
        builder: (_) => BasicDialogAlert(
          title: Text("Success"),
          content: Text(
            "The report \"${_args.report.title}\" was successfully removed from your reports dashboard.",
          ),
          actions: <Widget>[
            BasicDialogAction(
              title: Text(
                "Close",
              ),
              onPressed: () {
                Navigator.popUntil(
                  context,
                  ModalRoute.withName('/'),
                );
              },
            ),
          ],
        ),
      );
    });
  }
}
