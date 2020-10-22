import 'package:flutter/material.dart';
import 'package:medical/model/report_set_model.dart';
import 'package:medical/utils/provider_config.dart';
import 'package:provider/provider.dart';

/// 简单列表项
class SetReportPage extends StatelessWidget {
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
      ),
      body: Container(
          padding: EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 50,
                ),
                Text("报告单显示编辑,设置你要展示录入的报告单字段信息,可以拖拽调整对应的顺序"),
                SizedBox(
                  height: 40,
                ),
                Divider(),
                ..._mode.repostTypes.map((e) => _reViewItem(e.name, () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) {
                        return ProviderConfig.getInstance()
                            .getReportSetDetailPage(e.id);
                      }));
                    }))
              ],
            ),
          )),
    );
  }

  Widget _reViewItem(name, tap, {divide: true}) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(
            name,
            style: TextStyle(fontSize: 14),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 16,
          ),
          contentPadding: const EdgeInsets.only(left: 30),
          onTap: () {
            tap();
          },
        ),
        divide ? Divider() : Container()
      ],
    );
  }
}
