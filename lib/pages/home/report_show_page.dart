import 'package:fdottedline/fdottedline.dart';
import 'package:flutter/material.dart';
import 'package:medical/bean/report_value_bean.dart';
import 'package:medical/model/global_model.dart';
import 'package:medical/model/report_model.dart';
import 'package:medical/utils/widget_util.dart';
import 'package:provider/provider.dart';

class ReportShowPage extends StatelessWidget {
  /**
   * 性别
   */

  Widget getSizeBox({height: 20.0}) {
    return SizedBox(
      height: height,
    );
  }

  List<Widget> getKeysValueList(model) {
    if (model.reportBean == null || model.reportBean.id == null) {
      return [];
    }
    return List.generate(model.reportBean.reportValue.length, (index) {
      ReportValueBean reportValBean = model.reportBean.reportValue[index];
      return WidgetUtil().getReportItem(reportValBean);
    });
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
        // actions: <Widget>[
        //   IconButton(
        //     icon: Icon(
        //       Icons.check,
        //       color: Colors.black38,
        //     ),
        //     tooltip: "提交",
        //     onPressed: () {
        //       model.onSubmitTap(context);
        //     },
        //   )
        // ],
        title: Text(
          model.reportBean.reportTypeName ?? "",
          style: TextStyle(color: Colors.grey),
        ),
      ),
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            FDottedLine(
              color: Colors.grey,
              strokeWidth: 1.0,
              dottedLength: 8.0,
              space: 3.0,
              corner: FDottedLineCorner.all(10.0),
              child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.fromLTRB(10, 30, 10, 30),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "基本信息",
                        style: TextStyle(fontSize: 20),
                      ),
                      getSizeBox(height: 30.0),
                      WidgetUtil().getKeyValueItem("报告单类型:",
                          model.reportBean.reportTypeName, Colors.black),
                      WidgetUtil().getKeyValueItem(
                          "年龄:", model.reportBean.age, Colors.black),
                      WidgetUtil().getKeyValueItem(
                          "检查日期:", model.reportBean.reportDay, Colors.black),
                      WidgetUtil().getKeyValueItem(
                          "检测机构:", model.reportBean.testName, Colors.black),
                    ],
                  )),
            ),
            getSizeBox(height: 30.0),
            FDottedLine(
              color: Colors.grey,
              strokeWidth: 1.0,
              dottedLength: 8.0,
              space: 3.0,
              corner: FDottedLineCorner.all(10.0),
              child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.fromLTRB(10, 30, 10, 30),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "报告单",
                        style: TextStyle(fontSize: 20),
                      ),
                      getSizeBox(height: 30.0),
                      ...getKeysValueList(model),
                    ],
                  )),
            )

            // desc(model)
          ],
        ),
      ),
    );
  }
}
