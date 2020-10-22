import 'package:flutter/material.dart';
import 'package:medical/api/api_service.dart';
import 'package:medical/api/keys.dart';
import 'package:medical/bean/login_bean.dart';
import 'package:medical/utils/event_center.dart';
import 'package:medical/utils/global_uitl.dart';
import 'package:medical/utils/shared_util.dart';
import 'package:medical/utils/toast_util.dart';

import 'global_model.dart';

class LoginModel extends ChangeNotifier {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  BuildContext context;

  ///用于在mainPage销毁后将GlobalModel中的mainPageModel销毁
  GlobalModel _globalModel;
  /**
   * 注册使用的用户名,密码
   */
  String loginUserName;
  String loginPassword;

  /**
   * 注册使用
   */
  String registerMobile;
  String registerPassword;
  String registerConfirmPassword;

  void setContext(BuildContext context, {GlobalModel globalModel}) {
    if (this.context == null) {
      this.context = context;
      this._globalModel = globalModel;
    }
  }

  subLogin(context) async {
    if (loginUserName == null) {
      ToastUtil().showError("请输入有效的手机号");
      return;
    }

    if (loginPassword == null) {
      ToastUtil().showError("请输入密码");
      return;
    }
    ApiService.instance.login(
        params: {"mobile": loginUserName, "password": loginPassword},
        success: (LoginBean data) {
          dealLoginSuccess(data);
          Navigator.pop(context);
        },
        error: () {});
  }

  /**
   * 提交注册
   */
  subRegister(context) async {
    if (registerMobile == null) {
      ToastUtil().showError("请输入有效的手机号");
      return;
    }
    if (registerPassword == null) {
      ToastUtil().showError("请输入密码");
      return;
    }
    if (registerPassword != registerConfirmPassword) {
      ToastUtil().showError("两次输入密码不一致");
      return;
    }
    ApiService.instance.register(
        params: {"mobile": registerMobile, "password": registerPassword},
        failed: () {},
        success: (LoginBean data) {
          dealLoginSuccess(data);
          Navigator.pop(context);
        },
        error: (data) {});
  }

  dealLoginSuccess(data) {
    if (data != null) {
      SharedUtil.instance.saveGlobalString(Keys.token, data.token);
      GlobalUtil.getInstance().token = data.token;
      EventCenter().trigger(Keys.loginSuccess);
      _globalModel.setUser(data);
    }

    // Navigator.push(context, MaterialPageRoute(builder: (_) {
    //   return ProviderConfig.getInstance().getMainPage();
    // }));
  }

  setLoginPassword(value) {
    loginPassword = value;
  }

  setLoginMobile(value) {
    loginUserName = value;
  }

  /**
   * 设置密码
   */
  setPassword(value) {
    registerPassword = value;
  }

  setConfirmPassword(value) {
    registerConfirmPassword = value;
  }

  setMobile(value) {
    registerMobile = value;
  }

  @override
  void dispose() {
    super.dispose();
    scaffoldKey?.currentState?.dispose();
  }

  void refresh() {
    notifyListeners();
  }
}
