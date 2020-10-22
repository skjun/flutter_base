import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:medical/model/global_model.dart';
import 'package:medical/utils/provider_config.dart';
import 'package:medical/utils/widget_util.dart';
import 'package:provider/provider.dart';
import 'package:medical/pages/login/style/theme.dart' as mainTheme;

class HomePage extends StatelessWidget {
  //当任务列表为空时显示的内容

  Widget build(BuildContext context) {
    final model = Provider.of<GlobalModel>(context);
    final size = MediaQuery.of(context).size;
    final theMin = min(size.width, size.height) / 2;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: model.reports.length == 0
          ? Center(
              child: Container(
              height: 80,
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      "报告单为空",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  OutlineButton(
                    borderSide: BorderSide(color: Colors.white),
                    child: Text(
                      "新增",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) {
                        return ProviderConfig.getInstance()
                            .getReportDetailPage(null);
                      }));
                    },
                  )
                ],
              ),
            ))
          : Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SingleChildScrollView(
                    child: Row(
                      children: <Widget>[
                        ...model.userReportTypes.map((e) => FlatButton(
                              color: e.id == model.currentReportTypeId
                                  ? mainTheme.Colors.loginGradientEnd
                                  : null,
                              onPressed: () {
                                model.setCurReportType(e.id);
                              },
                              child: Text(
                                e.name,
                                style: TextStyle(
                                  color: e.id == model.currentReportTypeId
                                      ? Colors.white
                                      : null,
                                ),
                              ),
                            ))
                        // Tags(
                        //   itemCount: model.userReportTypes.length,
                        //   itemBuilder: (int index) {
                        //     return Tooltip(
                        //         message: model.userReportTypes[index].name,
                        //         child: ItemTags(
                        //           // singleItem: true,
                        //           elevation: 1,
                        //           index: index,
                        //           onPressed: (Item clickItem) {
                        //             model.setCurReportType(clickItem.index);
                        //           },
                        //           active: model.userReportTypes[index].id ==
                        //               model.currentReportTypeId,
                        //           activeColor:
                        //               mainTheme.Colors.loginGradientEnd,
                        //           title: model.userReportTypes[index].name,
                        //         ));
                        //   },
                        // )
                      ],
                    ),
                    scrollDirection: Axis.horizontal,
                  ),
                  SingleChildScrollView(
                      child: Container(
                    margin: EdgeInsets.only(top: 20, bottom: 20),
                    child: CarouselSlider(
                      items: WidgetUtil().getCards(model, context),
                      aspectRatio: 16 / 9,
                      height: size.height - 350,
                      viewportFraction: size.height >= size.width ? 0.8 : 0.5,
                      initialPage: 0,
                      enableInfiniteScroll: false,
                      reverse: false,
                      enlargeCenterPage: true,
                      onPageChanged: (index) {
                        // model.refresh();
                      },
                      scrollDirection: Axis.horizontal,
                    ),
                  )),
                ],
              ),
            ),
    );
  }
}
