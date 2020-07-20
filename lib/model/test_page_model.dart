import 'package:flutter/material.dart';

import 'global_model.dart';

class TestPageModel extends ChangeNotifier {

  BuildContext context;

  GlobalModel _globalModel;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();


  String test = "1.0";


  void setContext(BuildContext context, {GlobalModel globalModel}) {
    if (this.context == null) {
      this.context = context;
      this._globalModel = globalModel;
    }
  }
  @override
  void dispose() {
    super.dispose();
    scaffoldKey?.currentState?.dispose();
    debugPrint("TestPageModel销毁了");
  }

  void refresh() {
    notifyListeners();
  }
}

