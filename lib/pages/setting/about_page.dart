import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phonebase/api/api_service.dart';
import 'package:phonebase/bean/update_info_bean.dart';
import 'package:phonebase/i10n/localization_intl.dart';
import 'package:phonebase/model/global_model.dart';
import 'package:phonebase/pages/widgets/loading_widget.dart';
import 'package:phonebase/pages/widgets/net_loading_widget.dart';
import 'package:phonebase/pages/widgets/update_dialog.dart';
import 'package:provider/provider.dart';

import 'package:package_info/package_info.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  List<String> descriptions = [];

  @override
  Widget build(BuildContext context) {
    final globalModel = Provider.of<GlobalModel>(context);
    if (descriptions.isEmpty) {
      descriptions.add("IntlLocalizations.of(context).version112");
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          IntlLocalizations.of(context).aboutApp,
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
        backgroundColor: globalModel.getBgInDark(),
        iconTheme: IconThemeData(color: Colors.grey),
        elevation: 0.0,
      ),
      body: Container(
        color: globalModel.getBgInDark(),
        child: Container(
          margin: EdgeInsets.all(20),
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overScroll) {
              overScroll.disallowGlow();
              return true;
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 50, top: 2),
                      height: 90,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: Text(
                                "appName",
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.bottomLeft,
                                  child: FutureBuilder(
                                      future: PackageInfo.fromPlatform(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          PackageInfo packageInfo =
                                              snapshot.data;
                                          return Text(
                                            packageInfo.version,
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Theme.of(context)
                                                            .primaryColor ==
                                                        Color(0xff212121)
                                                    ? Colors.white
                                                    : Color.fromRGBO(
                                                        141, 141, 141, 1.0)),
                                          );
                                        } else
                                          return Container();
                                      }),
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                GestureDetector(
                                  child: Icon(
                                    Icons.cloud_upload,
                                  ),
                                  onTap: () => checkUpdate(globalModel),
                                )
                              ],
                            ),
                          ),
                          Row(
                            children: <Widget>[Text("检查升级...")],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void checkUpdate(GlobalModel globalModel) {
    final loadingController = globalModel.loadingController;

    showDialog(
        context: context,
        builder: (ctx) {
          CancelToken cancelToken = CancelToken();
          return NetLoadingWidget(
            loadingController: loadingController,
            successText: "noUpdate",
            onSuccess: () {
              Navigator.pop(context);
            },
            onRequest: () {
              ApiService.instance.checkUpdate(
                success: (UpdateInfoBean updateInfo) async {
                  final packageInfo = await PackageInfo.fromPlatform();
                  bool needUpdate = UpdateInfoBean.needUpdate(
                      packageInfo.version, updateInfo.appVersion);
                  if (needUpdate) {
                    Navigator.of(context).pop();
                    showDialog(
                        context: context,
                        builder: (ctx2) {
                          return UpdateDialog(
                            version: updateInfo.appVersion,
                            updateUrl: updateInfo.downloadUrl,
                            updateInfo: updateInfo.updateInfo,
                            updateInfoColor: globalModel.getBgInDark(),
                            backgroundColor:
                                globalModel.getPrimaryGreyInDark(context),
                          );
                        });
                  }
                  loadingController.setFlag(LoadingFlag.success);
                },
                error: (msg) {
                  loadingController.setFlag(LoadingFlag.error);
                },
                params: {
                  "language": globalModel.currentLocale.languageCode,
                  "appId": "001"
                },
                token: cancelToken,
              );
            },
            cancelToken: cancelToken,
          );
        });
  }
}
