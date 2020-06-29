import 'package:flutter/material.dart';


class CreateTeam extends StatefulWidget {
  static const String routeName = '/create-team';

  @override
  _CreateTeamState createState() => _CreateTeamState();
}

class _CreateTeamState extends State<CreateTeam> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create team")
      ),
    );
  }
}