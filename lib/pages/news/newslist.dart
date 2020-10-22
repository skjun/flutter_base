import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:medical/model/news_model.dart';
import 'package:medical/pages/news/new_item.dart';
import 'package:medical/pages/news/sample_list_item.dart';
import 'package:provider/provider.dart';

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  EasyRefreshController _controller = EasyRefreshController();

  List<Tab> contractInfoTables = [];

  NewsModel _newsModel;
  @override
  void dispose() {
    this._controller.dispose();
    super.dispose();
  }

  Widget newsContainer() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child:
          // getNewType(),
          EasyRefresh.custom(
        header: ClassicalHeader(
            refreshText: "下拉刷新",
            refreshReadyText: "松开后开始刷新",
            refreshingText: "正在刷新...",
            refreshedText: "刷新完成",
            bgColor: Colors.transparent,
            textColor: Colors.black87,
            infoText: "更新于 %T"),
        footer: ClassicalFooter(
          loadText: "上拉加载更多",
          loadReadyText: "松开后开始加载",
          loadingText: "正在加载...",
          loadedText: "加载完成",
          noMoreText: "没有更多内容了",
          infoText: "更新于 %T",
          bgColor: Colors.transparent,
          textColor: Colors.black87,
        ),
        controller: _controller,
        emptyWidget: _newsModel.newsData.length == 0
            ? Container(
                height: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: SizedBox(),
                      flex: 2,
                    ),
                    SizedBox(
                      width: 100.0,
                      height: 100.0,
                      child: Image.asset('resource/images/nodata.png'),
                    ),
                    Text(
                      "没有数据",
                      style: TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                    Expanded(
                      child: SizedBox(),
                      flex: 3,
                    ),
                  ],
                ),
              )
            : null,
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return SampleListItem(_newsModel.newsData[index], () {
                  _newsModel.jumpNewItem(context, _newsModel.newsData[index]);
                });
              },
              childCount: _newsModel.newsData.length,
            ),
          ),
        ],
        onRefresh: () async {
          _newsModel.loadData();
          // await Future.delayed(Duration(seconds: 2), () {
          //   if (mounted) {
          //     setState(() {
          //       _count = 20;
          //     });
          //   }
          // });
        },
        onLoad: () async {
          _newsModel.loadMoreData();
          // await Future.delayed(Duration(seconds: 2), () {
          //   if (mounted) {
          //     setState(() {
          //       _count += 20;
          //     });
          //   }
          // });
        },
      ),
    );
  }

  Widget loadWidget() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Center(
          child: SizedBox(
        height: 120.0,
        width: 200.0,
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 50.0,
                height: 50.0,
                child: SpinKitFadingCube(
                  color: Theme.of(context).primaryColor,
                  size: 25.0,
                ),
              ),
              Container(
                child: Text("加载中"),
              )
            ],
          ),
        ),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    _newsModel = Provider.of<NewsModel>(context)
      ..setContext(context, controller: _controller);
    return newsContainer();
  }
}
