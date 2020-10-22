import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:medical/bean/news.dart';

/// 简单列表项
class AboutPage extends StatelessWidget {
  /// 方向
  final Axis direction;

  /// 宽度
  final double width;

  const AboutPage({
    Key key,
    this.direction = Axis.vertical,
    this.width = double.infinity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black38),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "关于我们",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
          padding: EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 5,
                ),
                Text(
                    "这是一款记录报告数据的软件.不涉及商业用途.本来是自己使用.现在开放出来.共同使用.如果有问题,请直接联系我们,会劲量维护更新!")
              ],
            ),
          )),
    );
  }
}
