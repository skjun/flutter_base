import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:phonebase/api/keys.dart';
import 'package:phonebase/bean/color_bean.dart';
import 'package:phonebase/bean/theme_bean.dart';
import 'package:phonebase/pages/widgets/net_loading_widget.dart';
import 'package:phonebase/utils/shared_util.dart';
import 'package:phonebase/utils/theme_util.dart';

class GlobalModel extends ChangeNotifier {
  BuildContext context;

  ///GlobalModel可以用来统一管理所有的model，这里只管理了一部分

  ///app的名字
  String appName = '一日';

  ///当前的主题颜色数据
  ThemeBean currentThemeBean = ThemeBean(
    themeName: 'pink',
    colorBean: ColorBean.fromColor(MyThemeColor.defaultColor),
    themeType: MyTheme.defaultTheme,
  );

  ///是否开启自动夜间模式
  bool enableAutoDarkMode = false;

  ///当前自动夜间模式，白天的时间区间,比如：'7/20'
  String autoDarkModeTimeRange = '';

  ///当前语言
  List<String> currentLanguageCode = ['zh', 'CN'];
  String currentLanguage = '中文';
  Locale currentLocale;

  /**
   * 是否开启loading页面
   */
  bool showLoading = true;

  ///设置页面，用于loading加载框
  LoadingController loadingController = LoadingController();

  void setContext(BuildContext context) {
    if (this.context == null) {
      this.context = context;

      print(currentLanguageCode);
      Future.wait([
        //加载默认保存主题
        getCurrentTheme(),
        getCurrentLanguageCode(),
        getCurrentLanguage()
      ]).then((value) {
        chooseTheme();
        currentLocale = Locale(currentLanguageCode[0], currentLanguageCode[1]);
        refresh();
      });
    }
  }

  void setPageModel() {
    debugPrint("设置taskDetailPageModel");
  }

  ///获取当前的主题数据
  Future getCurrentTheme() async {
    final theme = await SharedUtil.instance.getString(Keys.currentThemeBean);
    if (theme == null) return;
    ThemeBean themeBean = ThemeBean.fromMap(jsonDecode(theme));
    if (themeBean.themeType == MyTheme.random) {
      themeBean.colorBean = ColorBean.fromColor(
          Colors.primaries[Random().nextInt(Colors.primaries.length)]);
    } else if (themeBean.themeType == this.currentThemeBean.themeType) return;
    this.currentThemeBean = themeBean;
  }

  ///获取当前的语言code
  Future getCurrentLanguageCode() async {
    final list =
        await SharedUtil.instance.getStringList(Keys.currentLanguageCode);
    if (list == null) return;
    if (list == currentLanguageCode) return;
    currentLanguageCode = list;
  }

  ///获取当前的语言
  Future getCurrentLanguage() async {
    final currentLanguage =
        await SharedUtil.instance.getString(Keys.currentLanguage);
    if (currentLanguage == null) return;
    if (currentLanguage == this.currentLanguage) return;
    this.currentLanguage = currentLanguage;
  }

  ///根据数据来决定显示什么主题
  void chooseTheme() {
    if (this.enableAutoDarkMode) return;
    if (this.autoDarkModeTimeRange.isEmpty) return;
    final times = this.autoDarkModeTimeRange.split('/');
    if (times.length < 2) return;
    final start = int.parse(times[0]);
    final end = int.parse(times[1]);
    final time = DateTime.now();
    if (time.hour < start || time.hour > end) {
      final String languageCode = this.currentLanguageCode[0];
      this.currentThemeBean = ThemeBean(
        themeName: languageCode == 'zh' ? '不见五指' : 'dark',
        colorBean: ColorBean.fromColor(MyThemeColor.darkColor),
        themeType: MyTheme.darkTheme,
      );
    }
  }

  //当为夜间模式时候，白色替换为灰色
  Color getWhiteInDark() {
    final themeType = currentThemeBean.themeType;
    return themeType == MyTheme.darkTheme ? Colors.grey : Colors.white;
  }

  Color getNavColor() {
    final themeType = currentThemeBean.themeType;
    return themeType == MyTheme.darkTheme
        ? Colors.black26
        : Color.fromRGBO(
            currentThemeBean.colorBean.red - 20 <= 0
                ? currentThemeBean.colorBean.red
                : currentThemeBean.colorBean.red - 20,
            currentThemeBean.colorBean.green - 20 <= 0
                ? currentThemeBean.colorBean.green
                : currentThemeBean.colorBean.green - 20,
            currentThemeBean.colorBean.blue - 20 <= 0
                ? currentThemeBean.colorBean.blue
                : currentThemeBean.colorBean.blue - 20,
            currentThemeBean.colorBean.opacity);
  }

  //当为夜间模式时候，白色背景替换为特定灰色
  Color getBgInDark() {
    final themeType = currentThemeBean.themeType;
    return themeType == MyTheme.darkTheme
        ? currentThemeBean.colorBean
        : Colors.white;
  }

  //当为夜间模式时候，主题色背景替换为灰色
  Color getPrimaryGreyInDark(BuildContext context) {
    final themeType = currentThemeBean.themeType;
    return themeType == MyTheme.darkTheme
        ? Colors.grey
        : Theme.of(context).primaryColor;
  }

  @override
  void dispose() {
    super.dispose();
    debugPrint("GlobalModel销毁了");
  }

  void refresh() {
    notifyListeners();
  }
}
