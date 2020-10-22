import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:medical/model/global_model.dart';
import 'package:medical/model/patient_model.dart';
import 'package:provider/provider.dart';

class PatientPage extends StatelessWidget {
  Widget userName(PatientPageModel model) {
    return Padding(
      padding: EdgeInsets.only(left: 50.0, right: 50),
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 20),
            width: 100,
            child: Text(
              "姓名:",
              style: TextStyle(),
              textAlign: TextAlign.left,
            ),
          ),
          Expanded(
            child: TextFormField(
              onChanged: (value) => model.setValue("name", value),
              autofocus: false,
              controller: new TextEditingController.fromValue(
                  new TextEditingValue(
                      text: model.oldPatient.name ?? "",
                      selection: new TextSelection.collapsed(
                          offset: model.oldPatient.name == null
                              ? 0
                              : model.oldPatient.name.length))),
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
   * 性别
   */
  Widget sex(PatientPageModel model) {
    return Padding(
      padding: EdgeInsets.only(left: 50.0, right: 50),
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 20),
            width: 100,
            child: Text(
              "性别:",
              style: TextStyle(),
              textAlign: TextAlign.left,
            ),
          ),
          Expanded(
              child: Container(
                  padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                  // height: 35,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Color(0xffe5e5e5))),
                  child: new DropdownButtonHideUnderline(
                      child: new DropdownButton(
                    items: [
                      new DropdownMenuItem(
                        child: new Text('男'),
                        value: '男',
                      ),
                      new DropdownMenuItem(
                        child: new Text('女'),
                        value: '女',
                      ),
                    ],
                    hint: new Text('请选择'),
                    onChanged: (value) {
                      model.setValue("sex", value);
                    },
                    value: model.oldPatient.sex == null
                        ? "男"
                        : model.oldPatient.sex,
                    elevation: 1, //设置阴影的高度
                    style: new TextStyle(
                      //设置文本框里面文字的样式
                      color: Color(0xff4a4a4a),
                      fontSize: 12,
                    ),

//              isDense: false,//减少按钮的高度。默认情况下，此按钮的高度与其菜单项的高度相同。如果isDense为true，则按钮的高度减少约一半。 这个当按钮嵌入添加的容器中时，非常有用
                    iconSize: 30.0,
                  ))))
        ],
      ),
    );
  }

  /**
   * 出身年月
   */
  Widget birth(PatientPageModel model, context) {
    return Padding(
      padding: EdgeInsets.only(left: 50.0, right: 50),
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 20),
            width: 100,
            child: Text(
              "出生日期:",
              style: TextStyle(),
              textAlign: TextAlign.left,
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                showChoseData(context, model);
              },
              child: TextFormField(
                // onChanged: (value) => model.setValue("name", value),
                autofocus: false,
                enabled: false,
                controller: new TextEditingController.fromValue(
                    new TextEditingValue(
                        text: model.oldPatient.birth ?? "",
                        selection: new TextSelection.collapsed(
                            offset: model.oldPatient.name == null
                                ? 0
                                : model.oldPatient.name.length))),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                ),
              ),
            ),
          ),
          Container(
            width: 50,
            child: IconButton(
                onPressed: () {
                  showChoseData(context, model);
                },
                icon: Icon(Icons.calendar_today)),
          )
        ],
      ),
    );
  }

  showChoseData(context, model) {
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        maxTime: DateTime.now(),
        onChanged: (date) {}, onConfirm: (date) {
      model.setValue("birth", DateUtil.formatDate(date, format: "yyyy-MM-dd"));
    },
        currentTime: model.oldPatient.birth == null
            ? DateTime.now()
            : DateUtil.getDateTime(model.oldPatient.birth),
        locale: LocaleType.zh);
  }

/**
   * 介绍
   */
  Widget desc(PatientPageModel model) {
    return Padding(
      padding: EdgeInsets.only(left: 50.0, right: 50),
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 20),
            width: 100,
            child: Text(
              "介绍:",
              style: TextStyle(),
              textAlign: TextAlign.left,
            ),
          ),
          Expanded(
            child: TextFormField(
              onChanged: (value) => model.setValue("desc", value),
              autofocus: false,
              maxLines: 4,
              controller: new TextEditingController.fromValue(
                  new TextEditingValue(
                      text: model.oldPatient.name ?? "",
                      selection: new TextSelection.collapsed(
                          offset: model.oldPatient.name == null
                              ? 0
                              : model.oldPatient.name.length))),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    final tgl = Provider.of<GlobalModel>(context);
    final PatientPageModel model = Provider.of<PatientPageModel>(context);
    model.setContext(context, gl: tgl);
    final bgColor = tgl.getBgInDark();
    Color textColor = Colors.grey;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black38),
        backgroundColor: bgColor,
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.check,
              color: Colors.black38,
            ),
            tooltip: "提交",
            onPressed: () {
              model.onSubmitTap(context);
            },
          )
        ],
        title: Text(
          model.getHintTitle(),
          style: TextStyle(color: textColor),
        ),
      ),
      backgroundColor: bgColor,
      body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            // 触摸收起键盘
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 40, right: 40),
                  child: Text("       报告记录人员,请如实填写性别,出生日期,系统展示报告单时.会计算当时的年龄"),
                ),
                SizedBox(
                  height: 30,
                ),
                userName(model),
                SizedBox(
                  height: 30,
                ),
                sex(model),
                SizedBox(
                  height: 30,
                ),
                birth(model, context),
                SizedBox(
                  height: 30,
                ),
                // desc(model)
              ],
            ),
          )),
    );
  }
}
