import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phonebase/i10n/localization_intl.dart';
import 'package:phonebase/model/global_model.dart';
import 'package:phonebase/pages/setting/about_page.dart';
import 'package:phonebase/pages/setting/language_page.dart';
import 'package:phonebase/utils/provider_config.dart';
import 'package:provider/provider.dart';

class NavPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final globalModel = Provider.of<GlobalModel>(context);

    print(IntlLocalizations.of(context));
    return ListView(
      padding: EdgeInsets.all(0),
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 60, bottom: 60),
          child: Text(
            IntlLocalizations.of(context).settingTitle,
            style: TextStyle(fontSize: 30),
            textAlign: TextAlign.center,
          ),
        ),
        ListTile(
          title: Text(IntlLocalizations.of(context).changeTheme),
          leading: Icon(Icons.color_lens),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () {
            Navigator.push(context, CupertinoPageRoute(builder: (ctx) {
              return ProviderConfig.getInstance().getThemePage();
            }));
          },
        ),
        ListTile(
          title: Text(IntlLocalizations.of(context).languageTitle),
          leading: Icon(Icons.language),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () {
            Navigator.push(context, CupertinoPageRoute(builder: (ctx) {
              return LanguagePage();
            }));
          },
        ),
        ListTile(
          title: Text(IntlLocalizations.of(context).aboutApp),
          leading: Icon(Icons.settings),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () {
            Navigator.push(context, CupertinoPageRoute(builder: (ctx) {
              return AboutPage();
            }));
          },
        ),
      ],
    );
  }
}
