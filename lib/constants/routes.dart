import 'package:flutter/material.dart';
import 'package:team_tracker/pages/create_team.dart';
import 'package:team_tracker/pages/dashboard.dart';
import 'package:team_tracker/pages/report_detail.dart';
import 'package:team_tracker/pages/report_form.dart';
import 'package:team_tracker/ui/ui.dart';
import 'package:team_tracker/ui/auth/auth.dart';

class Routes {
  Routes._(); //this is to prevent anyone from instantiating this object
  static const String signin = '/signin';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String dashboard = '/dashboard';
  static const String settings = '/settings';
  static const String resetPassword = '/reset-password';
  static const String updateProfile = '/update-profile';
  static const String reportForm = '/report-form';
  static const String reportDetails = '/report-details';
  static const String createTeam = '/create-team';

  static final routes = <String, WidgetBuilder>{
    signin: (BuildContext context) => SignInUI(),
    signup: (BuildContext context) => SignUpUI(),
    settings: (BuildContext context) => SettingsUI(),
    resetPassword: (BuildContext context) => ResetPasswordUI(),
    updateProfile: (BuildContext context) => UpdateProfileUI(),
    reportForm: (BuildContext context) => ReportFormScreen(ReportFormScreenArgs(reportFormState: ReportFormState.ADD)),
    dashboard: (BuildContext context) => DashboardScreen(),
    reportDetails: (BuildContext context) => ReportDetailScreen(),
    createTeam: (BuildContext context) => CreateTeam()
  };
}
