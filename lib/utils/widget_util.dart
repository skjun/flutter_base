// 发布订阅
import 'package:flutter/material.dart';
import 'package:medical/bean/report_bean.dart';
import 'package:medical/model/global_model.dart';
import 'package:medical/pages/widgets/task_item.dart';
import 'package:medical/utils/provider_config.dart';

class WidgetUtil {
  WidgetUtil();
  /**
   * 获取按钮图标
   */
  static Widget getIconText({Icon icon, String text, VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.fromLTRB(10, 4, 10, 4),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.grey.withOpacity(0.2)),
        child: Row(
          children: <Widget>[
            icon,
            SizedBox(
              width: 4,
            ),
            Text(text),
          ],
        ),
      ),
    );
  }

  List<Widget> getCards(GlobalModel _model, context) {
    List<ReportBean> filterReports = [];

    if (_model.currentReportTypeId == 0) {
      filterReports = _model.reports;
    } else {
      _model.reports.forEach((element) {
        if (element.reportTypeId == _model.currentReportTypeId) {
          filterReports.add(element);
        }
      });
    }

    return List.generate(filterReports.length, (index) {
      ReportBean reportBean = filterReports[index];
      return GestureDetector(
        child: TaskItem(reportBean.id, reportBean,
            onEdit: () => _model.editReport(reportBean, context),
            onDelete: () {
              showDialog(
                  context: context,
                  builder: (ctx) {
                    return AlertDialog(
                      title: Text("删除报告单"),
                      actions: <Widget>[
                        FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "取消",
                              style: TextStyle(color: Colors.grey),
                            )),
                        FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              _model.deleteReport(reportBean);
                            },
                            child: Text(
                              "删除",
                              style: TextStyle(color: Colors.redAccent),
                            )),
                      ],
                    );
                  });
            }),
        onTap: () {
          // _model.currentTapIndex = index;
          Navigator.of(context).push(new PageRouteBuilder(
              pageBuilder: (ctx, anm, anmS) {
                return ProviderConfig.getInstance()
                    .getReportForShow(reportBean);
              },
              // opaque: false,
              transitionDuration: Duration(milliseconds: 600)));
        },
      );
    });
  }

  /**
   * card包裹组件
   */
  Widget cardConvert(child, {title: null}) {
    return Card(
        elevation: 1,
        child: Column(
          children: <Widget>[
            title == null
                ? Container(
                    height: 0,
                  )
                : Container(
                    padding: EdgeInsets.only(top: 5, bottom: 5),
                    child: Text(
                      title,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
            child,
          ],
        ));
  }

  /**
   * 加载报告单页面数据
   */
  Widget getReportItem(element) {
    return getKeyValueItem("${element.short_name}:", element.user_value,
        element.status == 0 ? Colors.black : Colors.redAccent[700]);
  }

  Widget getKeyValueItem(title, value, color, {double width: 60}) {
    width = (value == null ? 15 : value.toString().length * 15).toDouble();
    return Padding(
        padding: EdgeInsets.only(bottom: 5, top: 5),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                // padding: EdgeInsets.only(right: 20),
                child: Text(
                  "${title}",
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            Container(
              width: width,
              child: Text(
                "${value}",
                style: TextStyle(color: color),
                textAlign: TextAlign.right,
              ),
            )
          ],
        ));
  }
}
