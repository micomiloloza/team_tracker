// Copyright 2020 Joshua de Guzman (https://joshuadeguzman.github.io). All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:team_tracker/pages/create_team.dart';
import 'package:team_tracker/pages/report_form.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:team_tracker/pages/reports.dart';
import 'package:team_tracker/services/auth_service.dart';
import 'package:team_tracker/services/services.dart';
import 'package:provider/provider.dart';
import 'package:team_tracker/ui/ui.dart';
import '../services/auth_service.dart';

class DashboardScreen extends StatefulWidget {
  static const String routeName = "/dashboard";

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  // selected index of Bottom navigation bar
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    ReportsScreen(),
    HomeUI()
  ];
  
  @override
  void initState() {
    super.initState();
    _checkEmailVerification();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Team Tracker", style: Theme.of(context).textTheme.headline5),
        backgroundColor: themeProvider.isDarkModeOn ? Colors.black12 : Colors.white,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).pushNamed('/settings');
          })
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      floatingActionButton: SpeedDial(
        backgroundColor: Colors.orange,
        animatedIcon: AnimatedIcons.add_event,
        children: [
          SpeedDialChild(
            child: Icon(Icons.report),
            backgroundColor: Colors.blue,
            label: 'Submit New Report',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              Navigator.pushNamed(
                context,
                ReportFormScreen.routeName,
                arguments: ReportFormScreenArgs(reportFormState: ReportFormState.EDIT),
              );
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.report),
            backgroundColor: Colors.blue,
            label: 'Create team',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              Navigator.pushNamed(
                context,
                CreateTeam.routeName,
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            title: Text("Reports"),
            icon: Icon(FontAwesomeIcons.calendar),
          ),
          BottomNavigationBarItem(
            title: Text("Profile"),
            icon: Icon(FontAwesomeIcons.user),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showVerifyEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BasicDialogAlert(
          title: Text("Verify your account"),
          content: Text("Link to verify account has been sent to your email"),
          actions: <Widget>[
            BasicDialogAction(
              title: Text("Dismiss"),
              onPressed: (){
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  void _showVerifyEmailDialog() {
   showDialog(
     context: context,
     builder: (BuildContext context) {
      return BasicDialogAlert(
        title: Text("Verify your account"),
          content: Text("Please verify account in the link sent to email"),
          actions: <Widget>[
            BasicDialogAction(
              title: Text("Resend link"),
              onPressed: () {
                Navigator.of(context).pop();
                _resentVerifyEmail();
              },
            ),
            BasicDialogAction(
              title: Text("Dismiss"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
         ],
       );
     },
   );
 }

 void _checkEmailVerification() async {
   AuthService _auth = AuthService();
    _auth.isEmailVerified().then((isVerified) {
      if (!isVerified) {
        _showVerifyEmailDialog();
      }
    });
 }

 void _resentVerifyEmail(){
   AuthService _auth = AuthService();
   _auth.sendEmailVerification();
   _showVerifyEmailSentDialog();
 }
}
