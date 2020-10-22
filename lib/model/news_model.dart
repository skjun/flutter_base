import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:medical/api/api_service.dart';
import 'package:medical/bean/news.dart';
import 'package:medical/bean/page.dart';
import 'package:medical/model/global_model.dart';
import 'package:medical/pages/news/new_item.dart';
import 'package:medical/utils/toast_util.dart';

class NewsModel extends ChangeNotifier {
  GlobalModel globalModel;

  BuildContext context;
  EasyRefreshController _controller;

  PageVo pageVo;
  List<News> newsData = [];
  /**
   * 构造函数
   */
  NewsModel() {
    loadData();
  }

  void setContext(BuildContext context,
      {GlobalModel gl, EasyRefreshController controller}) {
    this.globalModel = gl;
    this._controller = controller;
    if (this.context == null) {
      this.context = context;
    }
  }

  loadData() {
    ApiService().getBlogs(
        params: {"page": "1"},
        success: (data) {
          if (data != null) {
            pageVo = PageVo.fromMap(data);
            List<News> leastNews =
                News.fromMapList(pageVo.datas).reversed.toList();

            leastNews.forEach((newitem) {
              bool exit = newsData.any((element) => element.id == newitem.id);
              if (!exit) {
                newsData.insert(0, newitem);
              }
            });

            _controller.finishRefresh();
            refresh();
          }

          print(data);
        },
        error: (er) {});
  }

  loadMoreData() {
    _controller.resetRefreshState();
    int page = 1;
    if (pageVo != null) {
      if (pageVo.curpage == pageVo.totalpage) {
        _controller.finishLoad(success: true, noMore: true);
        return;
      }
      page = pageVo.curpage + 1;
    }
    ApiService().getBlogs(
        params: {"page": page.toString()},
        success: (data) {
          if (data != null) {
            pageVo = PageVo.fromMap(data);
            List<News> anews = News.fromMapList(pageVo.datas);
            anews.forEach((element) {
              newsData.add(element);
            });
            // newsData.addAll(anews);
            // if (pageVo.totalpage == pageVo.curpage) {
            //   _controller.finishRefresh(success: true, noMore: true);
            // } else {
            // }
            _controller.finishRefresh();
            refresh();
          }

          print(data);
        },
        error: (er) {});
  }

  @override
  void dispose() {
    pageVo = null;
    newsData = [];
    super.dispose();
    debugPrint("NewsModel销毁了");
  }

  void refresh() {
    notifyListeners();
  }

  void jumpNewItem(BuildContext context, News newsData) {
    ApiService().getBlogItem(
        params: {"id": newsData.id.toString()},
        success: (data) {
          if (data == null) {
            ToastUtil().showError("新闻不存在");
            return;
          }
          News item = News.fromMap(data);
          Navigator.of(context).push(new PageRouteBuilder(
              pageBuilder: (ctx, anm, anmS) {
                return NewsItemPage(item);
              },
              // opaque: false,
              transitionDuration: Duration(milliseconds: 600)));
        },
        error: (e) {});
  }
}
