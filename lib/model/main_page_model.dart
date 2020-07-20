import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:phonebase/api/api_service.dart';
import 'package:phonebase/bean/color_bean.dart';
import 'package:phonebase/bean/update_info_bean.dart';
import 'package:phonebase/pages/widgets/update_dialog.dart';
import 'package:phonebase/utils/theme_util.dart';
import 'package:phonebase/utils/toast_util.dart';

import 'global_model.dart';

class MainPageModel extends ChangeNotifier {
  BuildContext context;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  ///当前卡片背景透明度
  double currentTransparency = 1.0;

  ///用于在mainPage销毁后将GlobalModel中的mainPageModel销毁
  GlobalModel _globalModel;

  ///是否开启主页背景渐变
  bool isBgGradient = false;

  ///是否开启主页背景颜色跟随卡片图标颜色
  bool isBgChangeWithCard = false;

  ///是否开启卡片图标颜色跟随主页背景
  bool isCardChangeWithBg = false;

  void setContext(BuildContext context, {GlobalModel globalModel}) {
    if (this.context == null) {
      this.context = context;
      ToastUtil.init(context);
      this._globalModel = globalModel;
    }
  }

  Decoration getBackground(GlobalModel globalModel) {
    bool isBgGradient = this.isBgGradient;
    bool isBgChangeWithCard = this.isBgChangeWithCard;

    return BoxDecoration(
      gradient: isBgGradient
          ? LinearGradient(
              colors: _getGradientColors(isBgChangeWithCard),
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter)
          : null,
      color: _getBgColor(isBgGradient, isBgChangeWithCard),
    );
  }

  List<Color> _getGradientColors(bool isBgChangeWithCard) {
    final context = this.context;
    if (!isBgChangeWithCard) {
      return [
        Theme.of(context).primaryColorLight,
        Theme.of(context).primaryColor,
        Theme.of(context).primaryColorDark,
      ];
    } else {
      return [
        ThemeUtil.getInstance().getLightColor(getCurrentCardColor()),
        getCurrentCardColor(),
        ThemeUtil.getInstance().getDarkColor(getCurrentCardColor()),
      ];
    }
  }

  Color _getBgColor(bool isBgGradient, bool isBgChangeWithCard) {
    if (isBgGradient) {
      return null;
    }
    final context = this.context;
    final primaryColor = Theme.of(context).primaryColor;
    return isBgChangeWithCard ? getCurrentCardColor() : primaryColor;
  }

  Color getCurrentCardColor() {
    return Theme.of(context).primaryColor;
//    final context = context;
//    final primaryColor = Theme.of(context).primaryColor;
//    int index = currentCardIndex;
//    int taskLength = _model.tasks.length;
//    if (taskLength == 0) return primaryColor;
//    if (index > taskLength - 1) return primaryColor;
//    return ColorBean.fromBean(_model.tasks[index].taskIconBean.colorBean);
  }

  void checkUpdate(GlobalModel globalModel) {
    if (Platform.isIOS) return;
    final context = this.context;
    CancelToken cancelToken = CancelToken();
    ApiService.instance.checkUpdate(
      success: (UpdateInfoBean updateInfo) async {
        final packageInfo = await PackageInfo.fromPlatform();
        bool needUpdate = UpdateInfoBean.needUpdate(
            packageInfo.version, updateInfo.appVersion);
        if (needUpdate) {
          showDialog(
              context: context,
              builder: (ctx2) {
                return UpdateDialog(
                  version: updateInfo.appVersion,
                  updateUrl: updateInfo.downloadUrl,
                  updateInfo: updateInfo.updateInfo,
                  updateInfoColor: globalModel.getBgInDark(),
                  backgroundColor: globalModel.getPrimaryGreyInDark(context),
                );
              });
        }
      },
      error: (msg) {},
      params: {
        "language": globalModel.currentLocale.languageCode,
        "appId": "001"
      },
      token: cancelToken,
    );
  }

  @override
  void dispose() {
    super.dispose();
    scaffoldKey?.currentState?.dispose();
    debugPrint("MainPageModel销毁了");
  }

  void refresh() {
    notifyListeners();
  }
}
