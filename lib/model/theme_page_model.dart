import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/material_picker.dart';
import 'package:phonebase/api/keys.dart';
import 'package:phonebase/bean/color_bean.dart';
import 'package:phonebase/bean/theme_bean.dart';
import 'package:phonebase/model/global_model.dart';
import 'package:phonebase/pages/widgets/custom_time_picker.dart';
import 'package:phonebase/utils/shared_util.dart';
import 'package:phonebase/utils/theme_util.dart';

class ThemePageModel extends ChangeNotifier {
  BuildContext context;
  Color customColor = Colors.black;

  List<ThemeBean> themes = [];
  bool isDeleting = false;

  void setContext(BuildContext context) {
    if (this.context == null) {
      this.context = context;
      getThemeList();
    }
  }

  removeIcon(int index) {
    SharedUtil.instance.readAndRemoveList(Keys.themeBeans, index - 7);
    getThemeList();
  }

  void getThemeList() async {
    final list = await ThemeUtil.getInstance().getThemeListWithCache(context);
    themes.clear();
    themes.addAll(list);
    if (list.length == 7) {
      isDeleting = false;
    }
    refresh();
  }

  void createCustomTheme() {
    _showColorPicker();
  }

  void _showColorPicker() {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            elevation: 0.0,
            title: Text("选择颜色"),
            content: SingleChildScrollView(
              child: MaterialPicker(
                pickerColor: Theme.of(context).primaryColor,
                onColorChanged: (color) {
                  customColor = color;
                },
                enableLabel: true,
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "取消",
                  style: TextStyle(color: Colors.redAccent),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("确定"),
                onPressed: () async {
                  final beans =
                      await SharedUtil.instance.readList(Keys.themeBeans) ?? [];
                  if (beans.length >= 10) {
                    _showCanNotAddTheme();
                    return;
                  }
                  ThemeBean themeBean = ThemeBean(
                    themeName: "customTheme" + " ${beans.length + 1}",
                    themeType: "customTheme" + " ${beans.length + 1}",
                    colorBean: ColorBean.fromColor(customColor),
                  );
                  final data = jsonEncode(themeBean.toMap());
                  beans.add(data);
                  SharedUtil.instance.saveStringList(Keys.themeBeans, beans);
                  getThemeList();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Widget getThemeBloc(ThemeBean themeBean, Size size, GlobalModel globalModel) {
    bool isCurrent = globalModel.currentThemeBean == themeBean;
    return InkWell(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      onTap: () {
        if (isCurrent) return;
        globalModel.currentThemeBean = themeBean;

        SharedUtil.instance
            .saveString(Keys.currentThemeBean, jsonEncode(themeBean.toMap()));
        globalModel.refresh();
      },
      child: Container(
        height: (size.width - 140) / 4,
        margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
        alignment: Alignment.center,
        child: Text(
          themeBean.themeName,
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
        decoration: BoxDecoration(
          color: themeBean.themeType == MyTheme.darkTheme
              ? Colors.black
              : ColorBean.fromBean(themeBean.colorBean),
          shape: BoxShape.rectangle,
          border: isCurrent ? Border.all(color: Colors.grey, width: 3) : null,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    );
  }

  Widget getRandomColorBloc(Size size, GlobalModel globalModel) {
    final themeBean = ThemeBean(
      themeName: "random",
      colorBean: ColorBean.fromColor(
          Colors.primaries[Random().nextInt(Colors.primaries.length)]),
      themeType: MyTheme.random,
    );
    bool isCurrent = globalModel.currentThemeBean == themeBean;
    return InkWell(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      onTap: () {
        globalModel.currentThemeBean = themeBean;
        globalModel.refresh();
        SharedUtil.instance
            .saveString(Keys.currentThemeBean, jsonEncode(themeBean.toMap()));
      },
      child: Container(
        height: (size.width - 140) / 4,
        margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
        alignment: Alignment.center,
        child: Text(
          themeBean.themeName,
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: isCurrent ? Border.all(color: Colors.grey, width: 2) : null,
          gradient: LinearGradient(colors: [
            Colors.primaries[Random().nextInt(Colors.primaries.length)],
            Colors.primaries[Random().nextInt(Colors.primaries.length)],
            Colors.primaries[Random().nextInt(Colors.primaries.length)],
          ], begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
      ),
    );
  }

  void onAutoThemeChanged(GlobalModel globalModel, bool value) async {
    if (value) {
      showModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: context,
          builder: (ctx) {
            return CustomTimePicker(
              callBack: (start, end) {
                globalModel.enableAutoDarkMode = value;
                globalModel.autoDarkModeTimeRange = '$start/$end';
                SharedUtil.instance.saveBoolean(
                    Keys.autoDarkMode, globalModel.enableAutoDarkMode);
                SharedUtil.instance.saveString(Keys.autoDarkModeTimeRange,
                    globalModel.autoDarkModeTimeRange);
                globalModel.chooseTheme();
                globalModel.refresh();
              },
            );
          });
    } else {
      globalModel.enableAutoDarkMode = value;
      SharedUtil.instance
          .saveBoolean(Keys.autoDarkMode, globalModel.enableAutoDarkMode);
      globalModel.getCurrentTheme().then((value) => globalModel.refresh());
    }
  }

  String getTimeRangeText(String time, bool needToShow) {
    if (time.isEmpty || !needToShow) return '';
    final times = time.split('/');
    if (time.length < 2) return '';
    return '${times[0]}-${times[1]}';
  }

  void _showCanNotAddTheme() {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: Text("canNotAddMoreTheme"),
          );
        });
  }

  @override
  void dispose() {
    super.dispose();
    debugPrint("ThemePageModel销毁了");
  }

  void refresh() {
    notifyListeners();
  }
}
