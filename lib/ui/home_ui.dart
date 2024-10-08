import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_tracker/localizations.dart';
import 'package:team_tracker/services/services.dart';
import 'package:team_tracker/models/models.dart';
import 'package:team_tracker/ui/components/components.dart';

class HomeUI extends StatefulWidget {
  @override
  _HomeUIState createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {
  bool _loading = true;
  String _uid = '';
  String _name = '';
  String _email = '';
  String _admin = '';
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    final labels = AppLocalizations.of(context);
    final UserModel user = Provider.of<UserModel>(context);
    if (user != null) {
      setState(() {
        _loading = false;
        _uid = user.uid;
        _name = user.name;
        _email = user.email;
      });
    }

    _isUserAdmin();

    return Scaffold(
      body: LoadingScreen(
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(height: 50),
              Avatar(user),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FormVerticalSpace(),
                  Text(labels.home.uidLabel + ': ' + _uid,
                      style: TextStyle(fontSize: 16)),
                  FormVerticalSpace(),
                  Text(labels.home.nameLabel + ': ' + _name,
                      style: TextStyle(fontSize: 16)),
                  FormVerticalSpace(),
                  Text(labels.home.emailLabel + ': ' + _email,
                      style: TextStyle(fontSize: 16)),
                  FormVerticalSpace(),
                  Text(labels.home.adminUserLabel + ': ' + _admin,
                      style: TextStyle(fontSize: 16)),
                ],
              ),
            ],
          ),
        ),
        inAsyncCall: _loading,
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
    );
  }

  _isUserAdmin() async {
    bool _isAdmin = await AuthService().isAdmin();
    //handle setState bug  //https://stackoverflow.com/questions/49340116/setstate-called-after-dispose
    if (mounted) {
      setState(() {
        _admin = _isAdmin.toString();
      });
    }
  }
}
