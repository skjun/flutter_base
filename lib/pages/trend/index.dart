import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:medical/model/global_model.dart';
import 'package:medical/model/trend_model.dart';
import 'package:medical/pages/trend/chart_item.dart';
import 'package:medical/utils/widget_util.dart';
import 'package:provider/provider.dart';

class TrendView extends StatefulWidget {
  @override
  _TrendViewState createState() => _TrendViewState();
}

class _TrendViewState extends State<TrendView> {
  @override
  Widget build(BuildContext context) {
    final global = Provider.of<GlobalModel>(context);
    final size = MediaQuery.of(context).size;
    TrendModel model = Provider.of<TrendModel>(context)
      ..setContext(context, gl: global)
      ..setSize(size.width);

    return Stack(
      children: <Widget>[
        SingleChildScrollView(
            child: Column(
          children: <Widget>[...model.repostTypes.map((e) => TrendItemView(e))],
        )),
        model.showDetail
            ? Positioned(
                top: 50,
                left: model.pleft ? 10 : null,
                right: model.pleft ? null : 10,
                child: Container(
                  padding: EdgeInsets.all(10),
                  color: Colors.white,
                  width: (size.width - 100) / 2,
                  // height: (size.height - 150) / 1.5,
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          ...model.tipdatas.map((element) {
                            return WidgetUtil().getReportItem(element);
                          })
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : Container()
      ],
    );
  }
}
