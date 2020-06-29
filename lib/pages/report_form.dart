// Copyright 2020 Joshua de Guzman (https://joshuadeguzman.github.io). All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:human_anatomy/human_anatomy.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:team_tracker/models/report_model.dart';
import 'package:team_tracker/constants/report_type.dart';
import 'package:team_tracker/services/auth_service.dart';
import 'package:team_tracker/viewmodel/reports_notifier.dart';
import 'package:team_tracker/ui/components/report_type_image_view.dart';
import 'package:provider/provider.dart';
import 'package:team_tracker/services/services.dart';
import 'package:team_tracker/ui/components/slider.dart';
import 'package:team_tracker/models/models.dart';


enum ReportFormState {
  ADD,
  EDIT,
}

class ReportFormScreenArgs {
  final ReportFormState reportFormState;
  final Report report;

  ReportFormScreenArgs({
    @required this.reportFormState,
    this.report,
  });
}

class ReportFormScreen extends StatefulWidget {
  static const String routeName = "/report-form";

  final ReportFormScreenArgs args;

  const ReportFormScreen(this.args);

  @override
  State<StatefulWidget> createState() => _ReportFormScreenState();
}

class _ReportFormScreenState extends State<ReportFormScreen> {
  ReportsNotifier _reportsNotifer;
  UserModel _user;

  final GlobalKey<FormState> _reportFormKey = GlobalKey<FormState>();
  final TextEditingController _titleTextEditingController =
      TextEditingController();
  final TextEditingController _hrvRateEditingController =
      TextEditingController();
  final TextEditingController _stepsMeasureController = TextEditingController();

  // MARK: - Sliders setup
  final internalTrainingLoadSlider = SliderWidget();
  final muscleSorenessSlider = SliderWidget();
  final painSlider = SliderWidget();
  final energyLevelSlider = SliderWidget();
  final moodSlider = SliderWidget();
  final yesterdayDailyStressSlider = SliderWidget();
  final sleepQualitySlider = SliderWidget();
  final sleepQuantitySlider = SliderWidget();

  ReportFormScreenArgs get _args => widget.args;
  ReportType _reportType = ReportType.training;

  @override
  void initState() {
    super.initState();

    setState(() {
      // _reportType = _getReportType();
      if (_args != null && _args.report != null) {
        _titleTextEditingController.text = _args.report.title;
        _hrvRateEditingController.text = _args.report.hrvMeasure.toString();
        _stepsMeasureController.text = _args.report.stepsMeasure.toString();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _reportsNotifer = Provider.of<ReportsNotifier>(context);
    _user = Provider.of<UserModel>(context);

    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text(
            _getReportTitle(),
            style: Theme.of(context).textTheme.headline5,
          ),
          backgroundColor: themeProvider.isDarkModeOn ? Colors.black12 : Colors.white,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _reportFormKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ReportTypeImageView(
                        height: 100,
                        width: 200,
                        type: _reportType,
                      ),
                    ],
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 16),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: <Widget>[
                  //       Text(
                  //         "Report Type",
                  //         style: Theme.of(context).textTheme.subtitle1,
                  //       ),
                  //       DropdownButton<String>(
                  //         hint: Text(_getReportTypeStr()),
                  //         items: <String>[
                  //           EnumToString.parse(ReportType.training),
                  //           EnumToString.parse(ReportType.game),
                  //           EnumToString.parse(ReportType.coordination),
                  //         ].map((String value) {
                  //           return DropdownMenuItem<String>(
                  //             value: value,
                  //             child: Text(value),
                  //           );
                  //         }).toList(),
                  //         onChanged: (value) {
                  //           setState(() {
                  //             _hasEditingStarted = true;
                  //             _reportType = EnumToString.fromString(
                  //               ReportType.values,
                  //               value,
                  //             );
                  //           });
                  //         },
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(top: 36),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // MARK: - Report title text field
                        // Text(
                        //   "Report Title",
                        //   style: Theme.of(context).textTheme.subtitle1,
                        // ),
                        // SizedBox(height: 10),
                        // TextFormField(
                        //   controller: _titleTextEditingController,
                        //   decoration: InputDecoration(
                        //     focusedBorder: OutlineInputBorder(
                        //         borderSide: BorderSide(color: Colors.blue)),
                        //     enabledBorder: OutlineInputBorder(
                        //         borderSide: BorderSide(color: Colors.grey)),
                        //     hintText: 'eg. Training Report #3',
                        //   ),
                        //   validator: (value) {
                        //     if (value.isEmpty) {
                        //       return 'Required';
                        //     }
                        //     return null;
                        //   },
                        // ),

                        // SizedBox(height: 50),

                        // MARK: - HRV rate measure text field
                        Text(
                          "HRV Measure",
                          style: Theme.of(context).textTheme.subtitle1,
                        ),

                        SizedBox(height: 10),
                        TextFormField(
                          controller: _hrvRateEditingController,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            hintText: 'HRV rate',
                          ),
                          minLines: 1,
                          maxLines: 1,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Required';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 50),

                        // MARK: - Smartphone steps measure text field
                        Text(
                          "Smartphone steps measure",
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _stepsMeasureController,
                          minLines: 1,
                          maxLines: 1,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            hintText: '12345',
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Required';
                            }
                            return null;
                          },
                        ),

                        // MARK: - Internal training load slider
                        _createElementWithPaddings(internalTrainingLoadSlider, "Internal training load"),

                        // MARK: - Muscle soreness slider
                        _createElementWithPaddings(muscleSorenessSlider, "Muscle soreness"),

                        // MARK: - Pain slider
                        _createElementWithPaddings(painSlider, "Pain"),

                        // MARK: - Energy slider
                        _createElementWithPaddings(energyLevelSlider, "Energy Level"),

                        // MARK: - Mood slider
                        _createElementWithPaddings(moodSlider, "Mood"),

                        // MARK: - Yesterday daily stress slider
                        _createElementWithPaddings(yesterdayDailyStressSlider, "Yesterday daily stress"),

                        // MARK: - Sleep quality slider
                        _createElementWithPaddings(sleepQualitySlider, "Sleep quality"),

                        // MARK: - Sleep quantity slider
                        _createElementWithPaddings(sleepQuantitySlider, "Sleep quantity"),
                      ],
                    ),
                  ),
                  Center(
                    child:  _addHumanObject(),
                  )
                ],
              ),
            ),
          ),
        ),
        persistentFooterButtons: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.red),
            ),
          ),
          FlatButton(
            onPressed: () {
              _submitForm();
            },
            child: Text(
              _getButtonTitle(),
            ),
          ),
        ],
      );
  }

  String _getReportTitle() {
    switch (_args.reportFormState) {
      case ReportFormState.EDIT:
        return "Edit report";
        break;
      default:
        return "Add new report";
    }
  }

Column _createElementWithPaddings(SliderWidget slider, String text) {
  return Column(children: [
    SizedBox(height: 50.0),
    Text(
      text,
      style: Theme.of(context).textTheme.subtitle1,
    ),
    SizedBox(height: 10.0),
    slider,
  ]);
}

HumanAnatomy _addHumanObject() {
  return HumanAnatomy();
}


  // String _getReportTypeStr() {
  //   switch (_args.reportFormState) {
  //     case ReportFormState.EDIT:
  //       if (_args.report != null && _hasEditingStarted == false) {
  //         return "Report type treba bit" + _args.report.sleepQuality.toString();
  //       } else {
  //         return EnumToString.parse(_reportType) ?? "";
  //       }
  //       break;
  //     default:
  //       return EnumToString.parse(_reportType) ?? "";
  //   }
  // }

  // ReportType _getReportType() {
  //   switch (_args.reportFormState) {
  //     case ReportFormState.EDIT:
  //       if (_args.report != null) {
  //         return EnumToString.fromString(
  //           ReportType.values,
  //           "Report type treba bit" + _args.report.pain.toString(),
  //         );
  //       } else {
  //         return ReportType.training;
  //       }
  //       break;
  //     default:
  //       return ReportType.training;
  //   }
  // }

  String _getButtonTitle() {
    switch (_args.reportFormState) {
      case ReportFormState.EDIT:
        return "Update";
        break;
      default:
        return "Submit New Report";
    }
  }

  void _submitForm() async {
    if (_reportFormKey.currentState.validate()) {
      String _reportId = "";
      AuthService _auth = AuthService();
      _auth.getUserId().then((userId) {
        if(_args != null && _args.report != null) _reportId = _args.report.id;
          Report _tempReport = Report(
            id: userId,
            author: _user.name,
            title: "Report " + DateFormat('dd-MM-yyyy').format(DateTime.now()),//_titleTextEditingController.text,
            internalTrainingLoad: internalTrainingLoadSlider.sliderV,
            muscleSoreness: muscleSorenessSlider.sliderV, 
            pain: painSlider.sliderV,
            hrvMeasure: num.parse(_hrvRateEditingController.text),
            energyLevel: energyLevelSlider.sliderV, 
            mood: moodSlider.sliderV, 
            yesterdayDailyStress: yesterdayDailyStressSlider.sliderV, 
            stepsMeasure: num.parse(_stepsMeasureController.text),
            sleepQuality: sleepQualitySlider.sliderV,
            sleepQuantity: sleepQuantitySlider.sliderV,
            timestamp: Timestamp.fromDate(DateTime.now())
          );

          switch (_args.reportFormState) {
            case ReportFormState.ADD:
              _reportsNotifer.createNewReport(_tempReport);
              
              break;
            case ReportFormState.EDIT:
              _reportsNotifer.updateReportDetails(_tempReport);
              break;
          }

          _showSubmitDialog();
      });
    }
  }

  String _getSuccessMessage() {
    switch (_args.reportFormState) {
      case ReportFormState.EDIT:
        return "Report successfully updated!";
        break;
      default:
        return "Report successfully submitted!";
    }
  }

  void _showSubmitDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => BasicDialogAlert(
        title: Text("Success"),
        content: Text(_getSuccessMessage()),
        actions: <Widget>[
          BasicDialogAction(
            title: Text("Close"),
            onPressed: () {
               Navigator.popUntil(
                context,
                ModalRoute.withName('/'),
              );
            },
          ),
        ],
      )
    );
  }
}
