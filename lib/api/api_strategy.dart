import 'dart:io';

import 'package:dio/dio.dart';
import 'package:medical/utils/global_uitl.dart';
import 'package:medical/utils/toast_util.dart';
export 'package:dio/dio.dart';

///Dio的封装类
class ApiStrategy {
  static ApiStrategy _instance;

  static final String baseUrl = "http://49.234.34.162:8088/";

  // static final String baseUrl = "http://medical:8888/";
  static const int connectTimeOut = 10 * 1000; //连接超时时间为10秒
  static const int receiveTimeOut = 15 * 1000; //响应超时时间为15秒

  static final String defaultPhoto =
      "${baseUrl}/assets/admin/img/defaultheader.jpg";
  Dio _client;

  static ApiStrategy getInstance() {
    if (_instance == null) {
      _instance = ApiStrategy._internal();
    }
    return _instance;
  }

  ApiStrategy._internal() {
    if (_client == null) {
      BaseOptions options = new BaseOptions();
      options.connectTimeout = connectTimeOut;
      options.receiveTimeout = receiveTimeOut;
      options.baseUrl = baseUrl;
      _client = new Dio(options);
      _client.interceptors.add(LogInterceptor(
        responseBody: true,
        requestHeader: false,
        responseHeader: false,
        request: false,
      )); //开启请求日志
    }
  }

  Dio get client => _client;
  static const String GET = "get";
  static const String POST = "post";

  static String getBaseUrl() {
    return baseUrl;
  }

  //get请求
  void get(
    String url,
    Function callBack, {
    Map<String, String> params,
    Function errorCallBack,
    CancelToken token,
  }) async {
    _request(
      url,
      callBack,
      method: GET,
      params: params,
      errorCallBack: errorCallBack,
      token: token,
    );
  }

  //post请求
  void post(
    String url,
    Function callBack, {
    Map<String, String> params,
    Function errorCallBack,
    CancelToken token,
  }) async {
    _request(
      url,
      callBack,
      method: POST,
      params: params,
      errorCallBack: errorCallBack,
      token: token,
    );
  }

  //post请求
  void postUpload(
    String url,
    Function callBack,
    ProgressCallback progressCallBack, {
    FormData formData,
    Function errorCallBack,
    CancelToken token,
  }) async {
    _request(
      url,
      callBack,
      method: POST,
      formData: formData,
      errorCallBack: errorCallBack,
      progressCallBack: progressCallBack,
      token: token,
    );
  }

  void _request(
    String url,
    Function callBack, {
    String method,
    Map<String, String> params,
    FormData formData,
    Function errorCallBack,
    ProgressCallback progressCallBack,
    CancelToken token,
  }) async {
    if (params != null && params.isNotEmpty) {
      print("<net> params :" + params.toString());
    }

    String errorMsg = "";
    int statusCode;

    var options = new Options(method: method, sendTimeout: 15000, headers: {
      "platform": Platform.operatingSystem,
      "token": GlobalUtil.getInstance().token != null
          ? GlobalUtil.getInstance().token
          : ""
    });

    try {
      Response response;
      if (method == GET) {
        //组合GET请求的参数
        if (params != null && params.isNotEmpty) {
          response = await _client.get(
            url,
            options: options,
            queryParameters: params,
            cancelToken: token,
          );
        } else {
          response = await _client.get(
            url,
            cancelToken: token,
            options: options,
          );
        }
      } else {
        if (params != null && params.isNotEmpty ||
            (formData != null && formData.length > 0)) {
          response = await _client.post(
            url,
            data: formData ?? new FormData.fromMap(params),
            onSendProgress: progressCallBack,
            cancelToken: token,
            options: options,
          );
        } else {
          response = await _client.post(
            url,
            cancelToken: token,
            options: options,
          );
        }
      }

      statusCode = response.statusCode;

      //处理错误部分
      if (statusCode < 0) {
        errorMsg = "网络请求错误,状态码:" + statusCode.toString();
        _handError(errorCallBack, errorMsg);
        return;
      }

      if (callBack != null) {
        var data = response.data;
        if (data['code'] != 200) {
          if (data['code'] == 401) {
            callBack(401);
            return;
          }

          ToastUtil().showError(data['message']);
          return;
        }
        callBack(data['data']);
      }
    } catch (e) {
      _handError(errorCallBack, e.toString());
    }
  }

  //处理异常
  static void _handError(Function errorCallback, String errorMsg) {
    if (errorCallback != null) {
      errorCallback(errorMsg);
    }
    print("<net> errorMsg :" + errorMsg);
  }
}
