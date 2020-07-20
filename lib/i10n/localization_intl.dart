import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'messages_all.dart'; //1

class IntlLocalizations {
  static Future<IntlLocalizations> load(Locale locale) {
    final String name =
        locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);
    //2
    return initializeMessages(localeName).then((b) {
      Intl.defaultLocale = localeName;
      return new IntlLocalizations();
    });
  }

  static IntlLocalizations of(BuildContext context) {
    return Localizations.of<IntlLocalizations>(context, IntlLocalizations);
  }

  String get settingTitle {
    return Intl.message(
      'Setting',
      name: 'settingTitle',
    );
  }

  String get changeTheme {
    return Intl.message(
      'Change Theme',
      name: 'changeTheme',
      desc: '切换主题',
    );
  }

  String get appName {
    return Intl.message(
      'appname',
      name: 'appName',
      desc: 'app名称',
    );
  }

  String get aboutApp {
    return Intl.message(
      '关于我们',
      name: 'aboutApp',
      desc: '关于',
    );
  }

  String get languageTitle {
    return Intl.message(
      'Change Language',
      name: 'languageTitle',
      desc: '修改语言',
    );
  }
}

//Locale代理类
class IntlLocalizationsDelegate
    extends LocalizationsDelegate<IntlLocalizations> {
  const IntlLocalizationsDelegate();

  //是否支持某个Local
  @override
  bool isSupported(Locale locale) => ['en', 'zh'].contains(locale.languageCode);

  // Flutter会调用此类加载相应的Locale资源类
  @override
  Future<IntlLocalizations> load(Locale locale) {
    //3
    return IntlLocalizations.load(locale);
  }

  // 当Localizations Widget重新build时，是否调用load重新加载Locale资源.
  @override
  bool shouldReload(IntlLocalizationsDelegate old) => false;
}
