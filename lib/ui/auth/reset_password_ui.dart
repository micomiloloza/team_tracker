import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:team_tracker/localizations.dart';
import 'package:team_tracker/ui/components/components.dart';
import 'package:team_tracker/helpers/helpers.dart';
import 'package:team_tracker/services/services.dart';

class ResetPasswordUI extends StatefulWidget {
  _ResetPasswordUIState createState() => _ResetPasswordUIState();
}

class _ResetPasswordUIState extends State<ResetPasswordUI> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _email = new TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isButtonDisabled = false;
  String email = '';
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    final labels = AppLocalizations.of(context);
    bool _loading = false;
    final themeProvider = Provider.of<ThemeProvider>(context);

    email = ModalRoute.of(context).settings.arguments;
    _email.text = email;

    return Scaffold(
      key: _scaffoldKey,
      appBar: appBar(themeProvider.isDarkModeOn),
      body: LoadingScreen(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    LogoGraphicHeader(),
                    SizedBox(height: 48.0),
                    FormInputFieldWithIcon(
                      controller: _email,
                      iconPrefix: Icons.email,
                      labelText: labels.auth.emailFormField,
                      validator: Validator(labels).email,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) =>
                          setState(() => _isButtonDisabled = false),
                      onSaved: (value) => _email.text = value,
                    ),
                    FormVerticalSpace(),
                    PrimaryButton(
                        labelText: labels.auth.resetPasswordButton,
                        onPressed: _isButtonDisabled
                            ? null
                            : () async {
                                if (_formKey.currentState.validate()) {
                                  setState(() =>
                                      _isButtonDisabled = !_isButtonDisabled);
                                  AuthService _auth = AuthService();
                                  await _auth
                                      .sendPasswordResetEmail(_email.text);

                                  _scaffoldKey.currentState
                                      .showSnackBar(SnackBar(
                                    content:
                                        Text(labels.auth.resetPasswordNotice),
                                  ));
                                }
                              }),
                    FormVerticalSpace(),
                    signInLink()
                  ],
                ),
              ),
            ),
          ),
        ),
        inAsyncCall: _loading,
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
    );
  }

  appBar(bool darkModeOn) {
    final labels = AppLocalizations.of(context);
    if ((email == '') || (email == null)) {
      return null;
    }
    return AppBar(
      title: Text(labels.auth.resetPasswordTitle,
      style: Theme.of(context).textTheme.headline5),
      backgroundColor: darkModeOn ? Colors.black12 : Colors.white);
  }

  signInLink() {
    final labels = AppLocalizations.of(context);
    if ((email == '') || (email == null)) {
      return LabelButton(
        labelText: labels.auth.signInonResetPasswordLabelButton,
        onPressed: () => Navigator.pushReplacementNamed(context, '/'),
      );
    }
    return Container(width: 0, height: 0);
  }
}
