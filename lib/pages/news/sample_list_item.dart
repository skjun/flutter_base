import 'package:flutter/material.dart';
import 'package:medical/bean/news.dart';

/// 简单列表项
class SampleListItem extends StatelessWidget {
  /// 方向
  final Axis direction;
  final Function onOpenClick;

  /// 宽度
  final double width;
  final News newItem;
  const SampleListItem(
    this.newItem,
    this.onOpenClick, {
    Key key,
    this.direction = Axis.vertical,
    this.width = double.infinity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          onOpenClick();
        },
        child: Container(
          child: Row(
            children: <Widget>[
              newItem.load_img != null && newItem.load_img != ""
                  ? Container(
                      width: 100,
                      height: 100,
                      // padding: EdgeInsets.all(10),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Image.network(newItem.load_img),
                      ),
                    )
                  : Container(),
              Expanded(
                flex: 1,
                child: Container(
                    height: 100,
                    padding: EdgeInsets.only(
                        left: 10.0, right: 10, top: 10, bottom: 10),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Text(
                                newItem.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Expanded(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          child: Text(
                            newItem.short_content,
                            textAlign: TextAlign.left,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
