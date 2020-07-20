import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:phonebase/routers/router_handler.dart';

class Routes {
// 路由管理
  static Router router = Router();
  static String indexPage = '/indexpage';

  static void configureRoutes(Router router) {
    // List widgetDemosList = new WidgetDemoList().getDemos();
    router.notFoundHandler = new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      print('route not found!');
    });

    /*  router.define(home, handler: homeHandler);
    router.define('/category/:type', handler: categoryHandler);
    router.define('/category/error/404', handler: widgetNotFoundHandler);*/
    router.define(indexPage, handler: indexPageHandler);
  }

  // 对参数进行encode，解决参数中有特殊字符，影响fluro路由匹配(https://www.jianshu.com/p/e575787d173c)
  static Future navigateTo(BuildContext context, String path,
      {Map<String, dynamic> params,
      bool clearStack = false,
      TransitionType transition = TransitionType.fadeIn}) {
    String query = "";
    if (params != null) {
      int index = 0;
      for (var key in params.keys) {
        var value = Uri.encodeComponent(params[key]);
        if (index == 0) {
          query = "?";
        } else {
          query = query + "\&";
        }
        query += "$key=$value";
        index++;
      }
    }
    print('我是navigateTo传递的参数：$query');

    path = path + query;
    return router.navigateTo(context, path,
        clearStack: clearStack, transition: transition);
  }

  // 对参数进行encode，解决参数中有特殊字符，影响fluro路由匹配(https://www.jianshu.com/p/e575787d173c)
  static Future navigatepushAndRemoveUntil(BuildContext context, String path,
      {Map<String, dynamic> params,
      bool clearStack = false,
      TransitionType transition = TransitionType.fadeIn}) {
    String query = "";
    if (params != null) {
      int index = 0;
      for (var key in params.keys) {
        var value = Uri.encodeComponent(params[key]);
        if (index == 0) {
          query = "?";
        } else {
          query = query + "\&";
        }
        query += "$key=$value";
        index++;
      }
    }
    path = path + query;
    return router.navigateTo(context, path,
        clearStack: clearStack, transition: transition);
  }
}
