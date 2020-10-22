import 'dart:math';

import 'package:medical/bean/common_bean.dart';
import 'package:medical/bean/login_bean.dart';
import 'package:medical/bean/report_bean.dart';
import 'package:medical/bean/report_type.dart';
import 'package:medical/bean/report_type_keys.dart';
import 'package:medical/bean/update_info_bean.dart';

import 'api_strategy.dart';
export 'package:dio/dio.dart';

///这里存放所有的网络请求接口
class ApiService {
  factory ApiService() => _getInstance();

  static ApiService get instance => _getInstance();
  static ApiService _instance;

  static final int requestSucceed = 200;
  static final int requestFailed = 1;

  ApiService._internal() {
    ///初始化
  }

  static ApiService _getInstance() {
    if (_instance == null) {
      _instance = new ApiService._internal();
    }
    return _instance;
  }

  ///通用的请求
  void postCommon(
      {Map<String, String> params,
      Function success,
      Function failed,
      Function error,
      String url,
      CancelToken token}) {
    ApiStrategy.getInstance().post(
        url,
        (data) {
          CommonBean commonBean = CommonBean.fromMap(data);
          if (commonBean.status == requestSucceed) {
            success(commonBean);
          } else {
            failed(commonBean);
          }
        },
        params: params,
        errorCallBack: (errorMessage) {
          error(errorMessage);
        },
        token: token);
  }

  ///检查更新
  void checkUpdate({
    Function success,
    Function error,
    Map<String, String> params,
    CancelToken token,
  }) {
    // UpdateInfoBean updateInfoBean = new UpdateInfoBean();
    // updateInfoBean.appVersion = "1.0.3";
    // //updateInfoBean.downloadUrl ="";
    // success(updateInfoBean);

    // return;
    ApiStrategy.getInstance().post(
      "api/checkUpdate",
      (data) {
        // 检查升级处理
        UpdateInfoBean updateInfoBean = UpdateInfoBean.fromMap(data);
        success(updateInfoBean);
      },
      params: params,
      errorCallBack: (errorMessage) {
        error(errorMessage);
      },
      token: token,
    );
  }

  ///登录
  void login({
    Map<String, String> params,
    Function success,
    Function failed,
    Function error,
    CancelToken token,
  }) {
    ApiStrategy.getInstance().post(
        "/api/login",
        (data) {
          LoginBean loginBean = LoginBean.fromMap(data);
          success(loginBean);
        },
        params: params,
        errorCallBack: (errorMessage) {
          if (error != null) {
            error(errorMessage);
          }
        },
        token: token);
  }

  void logout({
    Map<String, String> params,
    Function success,
    Function failed,
    Function error,
    CancelToken token,
  }) {
    ApiStrategy.getInstance().post(
        "/api/logout",
        (data) {
          success(null);
        },
        params: params,
        errorCallBack: (errorMessage) {
          if (error != null) {
            error(errorMessage);
          }
        },
        token: token);
  }

  ///邮箱验证码获取请求
  void getVerifyCode({
    Map<String, String> params,
    Function success,
    Function failed,
    Function error,
    CancelToken token,
  }) {
    postCommon(
      params: params,
      success: success,
      failed: failed,
      error: error,
      url: "fUser/identifyCodeSend",
      token: token,
    );
  }

  //邮箱验证码校验请求
  void postVerifyCheck(
      {Map<String, String> params,
      Function success,
      Function failed,
      Function error,
      CancelToken token}) {
    postCommon(
      params: params,
      success: success,
      failed: failed,
      error: error,
      url: "fUser/identifyCodeCheck",
      token: token,
    );
  }

  ///登录
  void register({
    Map<String, String> params,
    Function success,
    Function failed,
    Function error,
    CancelToken token,
  }) {
    ApiStrategy.getInstance().post(
        "api/register",
        (data) {
          LoginBean loginBean = LoginBean.fromMap(data);
          success(loginBean);
        },
        params: params,
        errorCallBack: (errorMessage) {
          if (error != null) {
            error(errorMessage);
          }
        },
        token: token);
  }

  ///登录
  void info({
    Map<String, String> params,
    Function success,
    Function failed,
    Function error,
    CancelToken token,
  }) {
    ApiStrategy.getInstance().get(
        "api/info",
        (data) {
          if (data == 401) {
            success(data);
          } else {
            LoginBean loginBean = LoginBean.fromMap(data);
            success(loginBean);
          }
        },
        params: params,
        errorCallBack: (errorMessage) {
          if (error != null) {
            error(errorMessage);
          }
        },
        token: token);
  }

  //加载病人数据
  void getPatients({
    Map<String, String> params,
    Function success,
    Function failed,
    Function error,
  }) {
    ApiStrategy.getInstance().get(
        "api/getPatients",
        (data) {
          success(data);
        },
        params: params,
        errorCallBack: (errorMessage) {
          if (error != null) {
            error(errorMessage);
          }
        });
  }

  //新增修改病人数据
  void savePatients({
    Map<String, String> params,
    Function success,
    Function failed,
    Function error,
  }) {
    ApiStrategy.getInstance().post(
        "api/createPatient",
        (data) {
          success(data);
        },
        params: params,
        errorCallBack: (errorMessage) {
          if (error != null) {
            error(errorMessage);
          }
        });
  }

  //新增修改病人数据
  void saveReport({
    Map<String, String> params,
    Function success,
    Function failed,
    Function error,
  }) {
    ApiStrategy.getInstance().post(
        "api/saveReportValue",
        (data) {
          success(data);
        },
        params: params,
        errorCallBack: (errorMessage) {
          if (error != null) {
            error(errorMessage);
          }
        });
  }

  //删除报告单数据
  void deleteReport({
    Map<String, String> params,
    Function success,
    Function failed,
    Function error,
  }) {
    ApiStrategy.getInstance().post(
        "api/delReport",
        (data) {
          success(data);
        },
        params: params,
        errorCallBack: (errorMessage) {
          if (error != null) {
            error(errorMessage);
          }
        });
  }

  //新增修改病人数据
  void getReports({
    Map<String, String> params,
    Function success,
    Function failed,
    Function error,
  }) {
    ApiStrategy.getInstance().get(
        "api/getUserReports",
        (data) {
          var reports = ReportBean.fromMapList(data);
          success(reports);
        },
        params: params,
        errorCallBack: (errorMessage) {
          if (error != null) {
            error(errorMessage);
          }
        });
  }

  void getReportTypes({
    Map<String, String> params,
    Function success,
    Function failed,
    Function error,
  }) {
    ApiStrategy.getInstance().get(
        "api/getReportTypeList",
        (data) {
          var types = ReportTypeBean.fromMapList(data);
          success(types);
        },
        params: params,
        errorCallBack: (errorMessage) {
          if (error != null) {
            error(errorMessage);
          }
        });
  }

  void getPatientTrend({
    Map<String, String> params,
    Function success,
    Function failed,
    Function error,
  }) {
    ApiStrategy.getInstance().get(
        "api/getTrendValue",
        (data) {
          success(data);
        },
        params: params,
        errorCallBack: (errorMessage) {
          if (error != null) {
            error(errorMessage);
          }
        });
  }

/**
 * 获取所有新闻数据
 */
  void getBlogs({
    Map<String, String> params,
    Function success,
    Function failed,
    Function error,
  }) {
    ApiStrategy.getInstance().get(
        "api/blogs",
        (data) {
          success(data);
        },
        params: params,
        errorCallBack: (errorMessage) {
          if (error != null) {
            error(errorMessage);
          }
        });
  }

  /**
   * 获取单个新闻页面
   */
  void getBlogItem({
    Map<String, String> params,
    Function success,
    Function failed,
    Function error,
  }) {
    ApiStrategy.getInstance().get(
        "api/getBlogItem",
        (data) {
          success(data);
        },
        params: params,
        errorCallBack: (errorMessage) {
          if (error != null) {
            error(errorMessage);
          }
        });
  }

  //获取用户报告单设置数据

  /**
   * 获取单个新闻页面
   * 输入 report_type_id :
   * 
   */
  void getUserReportKeys({
    Map<String, String> params,
    Function success,
    Function failed,
    Function error,
  }) {
    ApiStrategy.getInstance().get(
        "api/getUserReportKeys",
        (data) {
          print(data);
          success(ReportTypeKeysBean.fromMapList(data));
        },
        params: params,
        errorCallBack: (errorMessage) {
          if (error != null) {
            error(errorMessage);
          }
        });
  }

  void saveReportValue({
    Map<String, String> params,
    Function success,
    Function failed,
    Function error,
  }) {
    ApiStrategy.getInstance().post(
        "api/saveUserReportKeys",
        (data) {
          success(data);
        },
        params: params,
        errorCallBack: (errorMessage) {
          if (error != null) {
            error(errorMessage);
          }
        });
  }
}
