import 'package:draggable_flutter_list/draggable_flutter_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:medical/bean/report_type_keys.dart';
import 'package:medical/model/report_set_model.dart';
import 'package:provider/provider.dart';

/// 简单列表项
class SetReportDetailPage extends StatelessWidget {
  ReportSetModel _mode;
  @override
  Widget build(BuildContext context) {
    _mode = Provider.of<ReportSetModel>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black38),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "报告单设置",
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.check,
                color: Colors.red,
              ),
              tooltip: "保存",
              onPressed: () {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return new AlertDialog(
                        title: new Text(
                          '保存',
                          textAlign: TextAlign.center,
                        ),
                        content: Container(
                          height: 70,
                          child: Column(
                            children: <Widget>[
                              Html(
                                  data:
                                      '<div><p>确认编辑报告单信息.确认后,将使用当前报告单作为录入模板</p></div>')
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
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                          ),
                          new FlatButton(
                            color: Colors.red,
                            onPressed: () async {
                              //Function called
                              Navigator.pop(context);
                              _mode.subMit();
                            },
                            child: Text(
                              "同意",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            ),
                          ),
                        ],
                      );
                    });
              })
        ],
      ),
      body: DragAndDropList(
        _mode.reportKeys.length,
        itemBuilder: (BuildContext context, index) {
          ReportTypeKeysBean qo = _mode.reportKeys[index];

          return SizedBox(
            child: Card(
              child: ListTile(
                title: Row(
                  children: <Widget>[
                    Checkbox(
                      value: _mode.showIDs.indexOf(qo.id) != -1,
                      onChanged: (value) {
                        _mode.updateSelect(qo.id, value);
                      },
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  qo.name,
                                  textAlign: TextAlign.left,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                "单位:${qo.unit ?? "-"}",
                                textAlign: TextAlign.left,
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                "参考:${qo.right ?? ""}",
                                textAlign: TextAlign.left,
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
                contentPadding:
                    EdgeInsets.only(left: 10, right: 0, top: 5, bottom: 5),
                trailing: Container(
                  width: 100,
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        padding: EdgeInsets.all(2),
                        icon: Icon(Icons.arrow_upward),
                        onPressed: () {
                          if (index == 0) return;
                          int before = _mode.reportKeys.indexOf(qo);
                          int after = before - 1;
                          _mode.swapList(before, after);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_downward),
                        onPressed: () {
                          if (index == _mode.reportKeys.length - 1) return;
                          int before = _mode.reportKeys.indexOf(qo);
                          int after = before + 1;
                          _mode.swapList(before, after);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        onDragFinish: (before, after) {
          _mode.swapList(before, after);
        },
        canDrag: (index) {
          return index >= 0; //disable drag for index 3
        },
        canBeDraggedTo: (one, two) => true,
        dragElevation: 8.0,
      ),
      // ..._mode.reportKeys.map((e) => _reViewItem(e))
    );
  }

  Widget _reViewItem(ReportTypeKeysBean reportTypeKeysBean) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(
            reportTypeKeysBean.name,
            style: TextStyle(fontSize: 14),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 16,
          ),
          contentPadding: const EdgeInsets.only(left: 30),
          onTap: () {},
        ),
        Divider()
      ],
    );
  }
}
