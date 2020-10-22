import 'package:flutter/material.dart';
import 'package:medical/api/api_strategy.dart';
import 'package:medical/model/global_model.dart';
import 'package:medical/utils/provider_config.dart';
import 'package:provider/provider.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    final globalModel = Provider.of<GlobalModel>(context);
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 50),
                  width: 100,
                  height: 100,
                  child: Container(
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(ApiStrategy.defaultPhoto),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              globalModel.loginBean == null ? "" : globalModel.loginBean.mobile,
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            SizedBox(
              height: 10,
            ),
            Divider(),
            // _personalView("关于我们", () {}, divide: true),
            // _personalView("联系我们", () {}, divide: true),
            _personalView("报告单设置", () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                return ProviderConfig.getInstance().getReportSetPage();
              }));
            }, divide: true),
            _personalView("退出登录", () {
              globalModel.loginOut();
            }, divide: true),
          ],
        ),
      ),
    );
  }

  Widget _personalView(name, tap, {divide: true}) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(
            name,
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: Colors.white,
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
