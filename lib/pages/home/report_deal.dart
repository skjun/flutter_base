import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:medical/model/global_model.dart';
import 'package:medical/model/report_model.dart';
import 'package:medical/utils/provider_config.dart';
import 'package:provider/provider.dart';

class ReportPage extends StatelessWidget {
  /**
   * 性别
   */
  Widget reportType(ReportModel model) {
    return Padding(
      padding: EdgeInsets.only(left: 5, right: 5),
      child: Row(
        children: <Widget>[
          Expanded(
              child: Container(
                  width: 150,
                  // padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                  // height: 35,
                  // decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(8.0),
                  //     border: Border.all(color: Color(0xffe5e5e5))),
                  child: model.isEdit
                      ? Text(model.reportBean.reportTypeName,
                          textAlign: TextAlign.center,
                          style: new TextStyle(
                            //设置文本框里面文字的样式
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ))
                      : DropdownButtonHideUnderline(
                          child: new DropdownButton(
                          items: model.getReportTypeWidgets(),

                          hint: new Text('请选择'),
                          onChanged: (value) {
                            model.setReportType(value);
                          },
                          iconEnabledColor: Colors.red,
                          value: model.currentReportType == null
                              ? null
                              : model.currentReportType.id,
                          // value: model.oldPatient.sex == null
                          //     ? "男"
                          //     : model.oldPatient.sex,
                          elevation: 1, //设置阴影的高度
                          style: new TextStyle(
                            //设置文本框里面文字的样式
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),

                          //              isDense: false,//减少按钮的高度。默认情况下，此按钮的高度与其菜单项的高度相同。如果isDense为true，则按钮的高度减少约一半。 这个当按钮嵌入添加的容器中时，非常有用
                          iconSize: 30.0,
                        ))))
        ],
      ),
    );
  }

  Widget testName(ReportModel model) {
    return Padding(
      padding: EdgeInsets.only(left: 50.0, right: 50),
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 20),
            width: 100,
            child: Text(
              "检测机构:",
              style: TextStyle(),
              textAlign: TextAlign.left,
            ),
          ),
          Expanded(
            child: TextFormField(
              onChanged: (value) => model.setValue("testName", value),
              autofocus: false,
              controller: new TextEditingController.fromValue(
                  new TextEditingValue(
                      text: model.reportBean.testName ?? "",
                      selection: new TextSelection.collapsed(
                          offset: model.reportBean.testName == null
                              ? 0
                              : model.reportBean.testName.length))),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffe5e5e5)),
                    borderRadius: BorderRadius.circular(8.0)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /**
   *检查时间
   */
  Widget birth(ReportModel model, context) {
    return Padding(
      padding: EdgeInsets.only(left: 50.0, right: 50),
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 20),
            width: 100,
            child: Text(
              "报告单日期:",
              style: TextStyle(),
              textAlign: TextAlign.left,
            ),
          ),
          Expanded(
            child: TextFormField(
              // onChanged: (value) => model.setValue("name", value),
              autofocus: false,
              enabled: false,
              controller: new TextEditingController.fromValue(
                  new TextEditingValue(
                      text: model.reportBean.reportDay ?? "",
                      selection: new TextSelection.collapsed(
                          offset: model.reportBean.reportDay == null
                              ? 0
                              : model.reportBean.reportDay.length))),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0)),
              ),
            ),
          ),
          Container(
            width: 50,
            child: IconButton(
                onPressed: () {
                  DatePicker.showDatePicker(context,
                      showTitleActions: true,
                      maxTime: DateTime.now(),
                      onChanged: (date) {}, onConfirm: (date) {
                    model.setValue("reportDay",
                        DateUtil.formatDate(date, format: "yyyy-MM-dd"));
                  },
                      currentTime: model.reportBean.reportDay == null
                          ? DateTime.now()
                          : DateUtil.getDateTime(model.reportBean.reportDay),
                      locale: LocaleType.zh);
                },
                icon: Icon(Icons.calendar_today)),
          )
        ],
      ),
    );
  }

  Widget getSizeBox({height: 20.0}) {
    return SizedBox(
      height: height,
    );
  }

  jumpSetting(ReportModel model) {
    Navigator.push(model.context, MaterialPageRoute(builder: (_) {
      return ProviderConfig.getInstance()
          .getReportSetDetailPage(model.currentReportType.id);
    }));
  }

  Widget build(BuildContext context) {
    final tgl = Provider.of<GlobalModel>(context);
    final ReportModel model = Provider.of<ReportModel>(context);
    model.setContext(context, gl: tgl);
    final bgColor = tgl.getBgInDark();
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black38),
        backgroundColor: bgColor,
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.edit,
              color: Colors.red,
            ),
            tooltip: "编辑",
            onPressed: () {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return new AlertDialog(
                      title: new Text(
                        '报告单设置',
                        textAlign: TextAlign.center,
                      ),
                      content: Container(
                        height: 70,
                        child: Column(
                          children: <Widget>[
                            Html(
                                data:
                                    '<div><p>确认编辑报告单信息.确认后,当前保存的报告单信息都会丢失</p></div>')
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        new FlatButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "取消",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ),
                        new FlatButton(
                          color: Colors.red,
                          onPressed: () async {
                            //Function called
                            Navigator.pop(context);
                            jumpSetting(model);
                          },
                          child: Text(
                            "同意",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ),
                      ],
                    );
                  });
              //路由跳转
              // model.onEditReportPage(context);
            },
          ),
        ],
        title: reportType(model),
      ),
      backgroundColor: bgColor,
      body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            // 触摸收起键盘
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                getSizeBox(),
                birth(model, context),
                getSizeBox(),
                testName(model),
                getSizeBox(),
                Text(
                  "报告单信息",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ...model.getReportMetaWidgets(),

                SizedBox(
                  height: 50,
                ),

                model.currentReportType != null &&
                        model.currentReportType.reportTypeKeys != null &&
                        model.currentReportType.reportTypeKeys.length > 0
                    ? FlatButton(
                        padding: EdgeInsets.only(left: 50, right: 50),
                        color: Colors.green[400],
                        textColor: Colors.white,
                        onPressed: () {
                          model.onSubmitTap(context);
                        },
                        child: Text("保存"),
                      )
                    : FlatButton(
                        padding: EdgeInsets.only(left: 50, right: 50),
                        color: Colors.red,
                        textColor: Colors.white,
                        onPressed: () {
                          model.jumpSetting();
                        },
                        child: Text("设置报告单"),
                      )
                // desc(model)
              ],
            ),
          )),
    );
  }
}
