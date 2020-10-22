import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medical/api/api_strategy.dart';
import 'package:medical/api/keys.dart';
import 'package:medical/model/global_model.dart';
import 'package:medical/model/main_page_model.dart';
import 'package:medical/pages/home/home.dart';
import 'package:medical/pages/user/user.dart';
import 'package:medical/utils/event_center.dart';
import 'package:medical/utils/provider_config.dart';
import 'package:medical/utils/toast_util.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;

  List<Widget> container_views = [];

  GlobalModel globalModel;

  MainPageModel model;

  String _title = "";
  @override
  void initState() {
    super.initState();

    EventCenter().on(Keys.needLogin, (e) {
      Navigator.push(context, MaterialPageRoute(builder: (_) {
        return ProviderConfig.getInstance().getMainLogin();
      }));
    });

    EventCenter().on(Keys.openEditor, (e) {
      Navigator.push(context, CupertinoPageRoute(builder: (_) {
        return ProviderConfig.getInstance().getReportSetDetailPage(e.data);
      }));
    });

    container_views
      ..add(HomePage())
      ..add(ProviderConfig.getInstance().getTrendPageView())
      ..add(ProviderConfig.getInstance().getNewsPageView())
      ..add(UserPage());

    Future.delayed(Duration(seconds: 2), () {
      model.checkUpdate(globalModel);
    });
  }

// ignore: slash_for_doc_comments
  /**
   * @param selectIndex 当前选中的页面
   * @param index 每个条目对应的角标
   * @param iconData 每个条目对就的图标
   * @param title 每个条目对应的标题
   */
  buildBotomItem(int selectIndex, int index, IconData iconData, String title,
      GlobalModel globalModel) {
    //未选中状态的样式
    TextStyle textStyle =
        TextStyle(fontSize: 14.0, color: globalModel.getNavInDark(context));
    Color iconColor = globalModel.getNavInDark(context);
    double iconSize = 25;
    EdgeInsetsGeometry padding = EdgeInsets.only(top: 6.0);

    if (selectIndex == index) {
      //选中状态的文字样式
      textStyle = TextStyle(
          fontSize: 14.0, color: globalModel.getNavInActiveDark(context));
      //选中状态的按钮样式
      iconColor = globalModel.getNavInActiveDark(context);
      iconSize = 25;
      padding = EdgeInsets.only(top: 6.0);
    }
    Widget padItem = SizedBox();
    if (iconData != null) {
      padItem = Padding(
        padding: padding,
        child: Container(
          color: globalModel.getNavColor(),
          child: Center(
            child: Column(
              children: <Widget>[
                Icon(
                  iconData,
                  color: iconColor,
                  size: iconSize,
                ),
                Text(
                  title,
                  style: textStyle,
                )
              ],
            ),
          ),
        ),
      );
    }
    Widget item = Expanded(
      flex: 1,
      child: new GestureDetector(
        onTap: () {
          if (index != _currentIndex) {
            setState(() {
              _currentIndex = index;
              _title = title;
            });
          }
        },
        child: SizedBox(
          height: 55,
          child: padItem,
        ),
      ),
    );
    return item;
  }

  List<Widget> patients() {
    List<Widget> wigets = [];

    if (globalModel.patients != null) {
      globalModel.patients.forEach((element) {
        wigets.add(InkWell(
          onTap: () {
            globalModel.currentPatient = element;
            globalModel.refresh();
          },
          child: Container(
              height: 70,
              margin: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: NetworkImage(element.photo != null
                        ? element.photo
                        : ApiStrategy.defaultPhoto),
                  ),
                  Text(
                    element.name,
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  )
                ],
              )),
        ));
      });
    }
    return wigets;
  }

  Widget titleWidget() {
    return Container(
      // height: 50,
      padding: EdgeInsets.only(left: 20, right: 10, top: 20, bottom: 10),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              globalModel.currentPatient == null
                  ? Container(
                      height: 80,
                      width: 80,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(ApiStrategy.defaultPhoto),
                      ))
                  : Row(children: <Widget>[
                      Container(
                          height: 80,
                          width: 80,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(
                                globalModel.currentPatient.photo != null
                                    ? globalModel.currentPatient.photo
                                    : ApiStrategy.defaultPhoto),
                          )),
                      Container(
                        padding: EdgeInsets.only(left: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                                padding: EdgeInsets.only(left: 5, right: 5),
                                child: Text(
                                  globalModel.currentPatient.name,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: 20),
                                )),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                border: Border.all(
                                    color: Colors.orange, // set border color
                                    width: 3.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              // color: Colors.red,
                              padding: EdgeInsets.only(left: 5, right: 5),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    "${globalModel.currentPatient.age} ${globalModel.currentPatient.sex}",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 10),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ]),
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  OutlineButton(
                    padding: EdgeInsets.all(0),
                    onPressed: () {
                      Navigator.of(context).push(new PageRouteBuilder(
                          pageBuilder: (ctx, anm, anmS) {
                            return ProviderConfig.getInstance()
                                .getPatientPage(null);
                          },
                          // opaque: false,
                          transitionDuration: Duration(milliseconds: 400)));

                      // Navigator.of(context)
                      //     .push(MaterialPageRoute(builder: (_) {
                      //   return ProviderConfig.getInstance()
                      //       .getPatientPage(null);
                      // }));
                    },
                    child: Row(
                      children: <Widget>[Icon(Icons.add), Text("新增")],
                    ),
                  ),
                  globalModel.patients.length == 1
                      ? Container(
                          width: 10,
                        )
                      : Container(
                          margin: EdgeInsets.only(left: 10),
                          width: 40,
                          child: OutlineButton(
                              padding: EdgeInsets.all(0),
                              child: Icon(Icons.format_list_bulleted),
                              onPressed: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return new Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          ...globalModel.patients.map(
                                            (e) => new ListTile(
                                              leading: new Icon(
                                                  Icons.supervised_user_circle),
                                              title: new Text(e.name),
                                              onTap: () async {
                                                globalModel
                                                    .setCurrentPatient(e);
                                                Navigator.pop(context);
                                              },
                                            ),
                                          )
                                        ],
                                      );
                                    });
                              }),
                        )
                ],
              ))
            ],
          ),
        ],
      ),
      // child: Row(
      //   children: <Widget>[
      //     ...patients(),
      //     InkWell(
      //       onTap: () {
      //         // Routes.navigateTo(context, "/patient");
      //         // Routes.router.navigateTo(context, Routes.patient);
      //         Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      //           return ProviderConfig.getInstance()
      //               .getPatientPage(new Patients());
      //         }));
      //       },
      //       child: Container(
      //           height: 70,
      //           margin: EdgeInsets.all(10),
      //           child: Column(
      //             children: <Widget>[
      //               CircleAvatar(
      //                 child: Icon(
      //                   Icons.add,
      //                   color: Colors.white,
      //                 ),
      //               ),
      //               Text(
      //                 "新增",
      //                 style: TextStyle(fontSize: 14, color: Colors.white54),
      //               )
      //             ],
      //           )),
      //     ),
      //   ],
      // ),
    );
  }

  DateTime lastPopTime;
  Widget build(BuildContext context) {
    model = Provider.of<MainPageModel>(context);
    globalModel = Provider.of<GlobalModel>(context);
    final size = MediaQuery.of(context).size;
    model.setContext(context, globalModel: globalModel);

    return WillPopScope(
      child: Container(
        child: Scaffold(
          key: model.scaffoldKey,
          backgroundColor: Colors.transparent,
          appBar: _currentIndex > 1
              ? AppBar(
                  centerTitle: true,
                  backgroundColor: Colors.transparent,
                  title: Text(
                    _title,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 25),
                  ),
                )
              : PreferredSize(
                  preferredSize: Size.fromHeight(130),
                  child: titleWidget(),
                ),
          floatingActionButton: FloatingActionButton(
              tooltip: "new",
              backgroundColor: globalModel.getNavColor(),
              child: Icon(
                Icons.add,
                size: 30,
                color: Colors.white,
              ),
              onPressed: () {
                if (globalModel.patients.length == 0) {
                  Navigator.of(context).push(new PageRouteBuilder(
                      pageBuilder: (ctx, anm, anmS) {
                        return ProviderConfig.getInstance()
                            .getPatientPage(null);
                      },
                      // opaque: false,
                      transitionDuration: Duration(milliseconds: 400)));
                } else {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                    return ProviderConfig.getInstance()
                        .getReportDetailPage(null);
                  }));
                }
              }),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: BottomAppBar(
            //悬浮按钮 与其他菜单栏的结合方式
            shape: CircularNotchedRectangle(),
            // FloatingActionButton和BottomAppBar 之间的差距
            notchMargin: 8.0,
            color: globalModel.getNavColor(),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                buildBotomItem(_currentIndex, 0, Icons.home, "首页", globalModel),
                buildBotomItem(
                    _currentIndex, 1, Icons.insert_chart, "趋势", globalModel),
                buildBotomItem(_currentIndex, -1, null, "发现", globalModel),
                buildBotomItem(
                    _currentIndex, 2, Icons.description, "资讯", globalModel),
                buildBotomItem(
                    _currentIndex, 3, Icons.person, "我的", globalModel),
              ],
            ),
          ),
          body: container_views[_currentIndex],
        ),
      ),
      onWillPop: () {
        // 点击返回键的操作
        if (lastPopTime == null ||
            DateTime.now().difference(lastPopTime) > Duration(seconds: 2)) {
          lastPopTime = DateTime.now();
          ToastUtil().showCommon('再按一次退出应用');
        } else {
          lastPopTime = DateTime.now();
          // 退出app
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        }
      },
    );
  }
}
