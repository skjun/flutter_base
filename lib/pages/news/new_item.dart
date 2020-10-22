import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:medical/bean/news.dart';

/// 简单列表项
class NewsItemPage extends StatelessWidget {
  /// 方向
  final Axis direction;

  /// 宽度
  final double width;
  final News newItem;
  const NewsItemPage(
    this.newItem, {
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
          newItem.title,
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
                newItem.load_img != null && newItem.load_img != ""
                    ? Image.network(newItem.load_img)
                    : Container(),
                Html(data: newItem.post_content)
              ],
            ),
          )),
    );
  }
}
