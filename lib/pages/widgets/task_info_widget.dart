import 'package:flutter/material.dart';
import 'package:medical/bean/report_bean.dart';
import 'package:medical/pages/widgets/popmenu_botton.dart';
import 'package:medical/utils/widget_util.dart';

class TaskInfoWidget extends StatelessWidget {
  final int index;
  final double space;
  final ReportBean reportBean;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final bool isCardChangeWithBg;
  final bool isExisting;

  TaskInfoWidget(
    this.index, {
    this.space = 20,
    this.reportBean,
    this.onDelete,
    this.onEdit,
    this.isCardChangeWithBg = false,
    this.isExisting = false,
  });

  getReportList(ReportBean reportBean) {
    List<Widget> childs = [];
    if (reportBean.reportValue != null) {
      reportBean.reportValue.forEach((element) {
        childs.add(WidgetUtil().getReportItem(element));
      });
    }
    return childs;
  }

  @override
  Widget build(BuildContext context) {
    final iconColor = Theme.of(context).primaryColor;
    final textColor = Colors.black;

    return Column(
      // mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 10),
                child: Text(
                  "${reportBean.reportTypeName}(${reportBean.age})",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
                width: 42,
                height: 42,
                margin: EdgeInsets.only(top: 16),
                child: space == 20
                    ? SizedBox()
                    : Hero(
                        tag: "task_more$index",
                        child: Material(
                            color: Colors.transparent,
                            child: PopMenuBt(
                              iconColor: iconColor,
                              onDelete: onDelete,
                              onEdit: onEdit,
                              reportBean: reportBean,
                            )))),
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Expanded(
            child: Container(
          padding: EdgeInsets.only(bottom: 20),
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  WidgetUtil().getKeyValueItem(
                      "检测日期:", reportBean.reportDay, Colors.black),
                  ...getReportList(reportBean)
                ]),
          ),
        ))
      ],
    );
  }
}
