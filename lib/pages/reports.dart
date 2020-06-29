// Copyright 2020 Joshua de Guzman (https://joshuadeguzman.github.io). All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:team_tracker/models/report_model.dart';
import 'package:team_tracker/ui/components/reports_list_view.dart';
import 'package:team_tracker/helpers/firestore_helper.dart';

class ReportsScreen extends StatefulWidget {
  static const String routeName = "/reports";

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportsScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
       child: Center(
          child: ReportsListView((report) => _onRsvpClicked(report)),
        ), 
        color: Theme.of(context).scaffoldBackgroundColor,
    );
  }

  void _onRsvpClicked(Report report) {
    setState(() {
      showPlatformDialog(
        context: context,
        builder: (_) => BasicDialogAlert(
          title: Text("Confirm RSVP"),
          content: Text(
            "Would you like to confirm your RSVP to ${report.title} on ${FirestoreHelper.getReadableTime(report.timestamp)}?",
          ),
          actions: <Widget>[
            BasicDialogAction(
              title: Text(
                "Cancel",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            BasicDialogAction(
              title: Text("Confirm"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    });
  }
}
