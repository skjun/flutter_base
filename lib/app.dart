import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:phonebase/model/global_model.dart';
import 'package:phonebase/pages/borading/OnBoardingScreen.dart';
import 'package:phonebase/routers/routers.dart';
import 'package:phonebase/utils/provider_config.dart';
import 'package:phonebase/utils/theme_util.dart';
import 'package:provider/provider.dart';

import 'i10n/localization_intl.dart';

class Myapp extends StatefulWidget {
  @override
  _MyappState createState() => _MyappState();
}

class _MyappState extends State<Myapp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<GlobalModel>(context)..setContext(context);

    return MaterialApp(
      title: model.appName,
      localizationsDelegates: [
        // ... app-specific localization delegate[s] here
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        IntlLocalizationsDelegate()
      ],
      supportedLocales: [
        const Locale('en', 'US'), // 美国英语
        const Locale('zh', 'CN'), // 中文简体
      ],
      localeResolutionCallback:
          (Locale locale, Iterable<Locale> supportedLocales) {
        debugPrint(
            "locale:$locale   sups:$supportedLocales  currentLocale:${model.currentLocale}");
        if (model.currentLocale == locale) return model.currentLocale;
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale == locale) {
            model.currentLocale = locale;
            model.currentLanguageCode = [
              locale.languageCode,
              locale.countryCode
            ];
            locale.countryCode == "CN"
                ? model.currentLanguage = "中文"
                : model.currentLanguage = "English";
            return model.currentLocale;
          }
        }
        if (model.currentLocale == null) {
          model.currentLocale = Locale('zh', "CN");
          return model.currentLocale;
        }
        return model.currentLocale;
      },
      localeListResolutionCallback:
          (List<Locale> locales, Iterable<Locale> supportedLocales) {
        debugPrint("locatassss:$locales  sups:$supportedLocales");
        return model.currentLocale;
      },
      onGenerateRoute: Routes.router.generator,
      locale: model.currentLocale,
      theme: ThemeUtil.getInstance().getTheme(model.currentThemeBean),
      home: model.showLoading ? LandingPage() : getHomePage(),
    );
  }

  Widget getHomePage() {
    return ProviderConfig.getInstance().getMainPage();
  }
}
