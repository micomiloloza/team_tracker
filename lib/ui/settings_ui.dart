import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:team_tracker/ui/components/segmented_selector.dart';
import 'package:provider/provider.dart';
import 'package:team_tracker/localizations.dart';
import 'package:team_tracker/services/services.dart';
import 'package:team_tracker/ui/components/components.dart';
import 'package:team_tracker/models/models.dart';
import 'package:team_tracker/constants/constants.dart';

class SettingsUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final labels = AppLocalizations.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(labels.settings.title, style: Theme.of(context).textTheme.headline5),
        backgroundColor: themeProvider.isDarkModeOn ? Colors.black12 : Colors.white,
      ),
      body: _buildLayoutSection(context),
    );
  }

  Widget _buildLayoutSection(BuildContext context) {
    final labels = AppLocalizations.of(context);
    final List<MenuOptionsModel> themeOptions = [
      MenuOptionsModel(
          key: "system",
          value: labels.settings.system,
          icon: Icons.brightness_4),
      MenuOptionsModel(
          key: "light",
          value: labels.settings.light,
          icon: Icons.brightness_low),
      MenuOptionsModel(
          key: "dark", value: labels.settings.dark, icon: Icons.brightness_3)
    ];
    return ListView(
      children: <Widget>[
        ListTile(
          title: Text(labels.settings.language),
          trailing: DropdownPicker(
            menuOptions: Globals.languageOptions,
            selectedOption:
                Provider.of<LanguageProvider>(context).currentLanguage,
            onChanged: (value) {
              Provider.of<LanguageProvider>(context, listen: false)
                  .updateLanguage(value);
            },
          ),
        ),
        ListTile(
          title: Text(labels.settings.theme),
          trailing: SegmentedSelector(
            selectedOption: Provider.of<ThemeProvider>(context).getTheme,
            menuOptions: themeOptions,
            onValueChanged: (value) {
              Provider.of<ThemeProvider>(context, listen: false)
                  .updateTheme(value);
            },
          ),
        ),
        ListTile(
            title: Text(labels.settings.updateProfile),
            trailing: RaisedButton(
              onPressed: () async {
                Navigator.of(context).pushNamed('/update-profile');
              },
              child: Text(
                labels.settings.updateProfile,
              ),
            )),
        ListTile(
          title: Text(labels.settings.signOut),
          trailing: RaisedButton(
          onPressed: () {
            AuthService _auth = AuthService();
            _auth.signOut();
            //Navigator.pushReplacementNamed(context, '/signin');
          },
          child: Text(
            labels.settings.signOut,
          ),
        )),

        /*
        ListTile(
          title: Text(labels.settings.theme),
          trailing: DropdownPickerWithIcon(
            menuOptions: themeOptions,
            selectedOption: Provider.of<ThemeProvider>(context).getTheme,
            onChanged: (value) {
              Provider.of<ThemeProvider>(context, listen: false)
                  .updateTheme(value);
            },
          ),
        ),
        */
        /*    
        ListTile(
          title: Text(labels.settings.theme),
          trailing: CupertinoSlidingSegmentedControl(
            groupValue: Provider.of<ThemeProvider>(context).getTheme,
            children: myTabs,
            onValueChanged: (value) {
              Provider.of<ThemeProvider>(context, listen: false)
                  .updateTheme(value);
            },
          ),
        ),*/
      ],
    );
  }
}
