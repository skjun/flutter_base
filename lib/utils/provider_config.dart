import 'package:flutter/material.dart';
import 'package:phonebase/model/global_model.dart';
import 'package:phonebase/model/main_page_model.dart';
import 'package:phonebase/model/test_page_model.dart';
import 'package:phonebase/model/theme_page_model.dart';
import 'package:phonebase/pages/main/main_page.dart';
import 'package:phonebase/pages/main/mul_page.dart';
import 'package:phonebase/pages/setting/theme_page.dart';
import 'package:provider/provider.dart';

class ProviderConfig {
  static ProviderConfig _instance;

  static ProviderConfig getInstance() {
    if (_instance == null) {
      _instance = ProviderConfig._internal();
    }
    return _instance;
  }

  ProviderConfig._internal();

  ///全局provider
  ChangeNotifierProvider<GlobalModel> getGlobal(Widget child) {
    return ChangeNotifierProvider<GlobalModel>(
      create: (context) => GlobalModel(),
      child: child,
    );
  }

  ///主页provider
  ChangeNotifierProvider<MainPageModel> getMainPage() {
    return ChangeNotifierProvider<MainPageModel>(
      create: (context) => MainPageModel(),
      child: MainPage(),
    );
  }

  ///主页provider
  MultiProvider getMulPage() {
    return MultiProvider(
      providers: [
        Provider<GlobalModel>(create: (_) => GlobalModel()),
        Provider<TestPageModel>(create: (_) => TestPageModel()),
      ],
      child: MulPage(),
    );
  }

  ///主题设置页provider
  ChangeNotifierProvider<ThemePageModel> getThemePage() {
    return ChangeNotifierProvider<ThemePageModel>(
      create: (context) => ThemePageModel(),
      child: ThemePage(),
    );
  }
}
