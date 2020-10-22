import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:medical/bean/report_type.dart';
import 'package:medical/bean/report_type_keys.dart';
import 'package:medical/model/trend_model.dart';
import 'package:provider/provider.dart';

class TrendItemView extends StatelessWidget {
  ReportTypeBean reportTypeBean;
  ReportTypeKeysBean reportTypeKeysBean;
  List<Color> lineColors = [
    const Color(0xff72d8bf),
    const Color(0xffB386B8),
    const Color(0xffD8B24D),
    const Color(0xff44CEF6),
    const Color(0xff0096BF),
    const Color(0xffF619A1),
    const Color(0xff6EEB66),
    const Color(0xff0099CC),
    const Color(0xffFF6666),
    const Color(0xff009999),
    const Color(0xff993366),
    const Color(0xff99CCFF),
    const Color(0xffFFFFCC),
    const Color(0xff66CC99),
    const Color(0xff800080),
    const Color(0xff520057),
    const Color(0xff0023B4),
    const Color(0xff72d8bf),
    const Color(0xffB386B8),
    const Color(0xffD8B24D),
    const Color(0xff44CEF6),
    const Color(0xff0096BF),
    const Color(0xffF619A1),
    const Color(0xff6EEB66),
    const Color(0xff0099CC),
    const Color(0xffFF6666),
    const Color(0xff009999),
    const Color(0xff993366),
    const Color(0xff99CCFF),
    const Color(0xffFFFFCC),
    const Color(0xff66CC99),
    const Color(0xff800080),
    const Color(0xff520057),
    const Color(0xff0023B4),
  ];
  /**
   * 报告单标题
   */
  String title = "";
  /**
   * 报告单子标题
   */
  String subKeyTitle = "";

  List<String> xTitles = [];

  TrendItemView(ReportTypeBean bean) {
    this.reportTypeBean = bean;
    title = bean.name;
  }
  final Duration animDuration = const Duration(milliseconds: 250);
  int touchedIndex;
  final Color barBackgroundColor = const Color(0xff72d8bf);

  LineChartData getChartData(TrendModel trendModel) {
    List<int> selectKeys = trendModel.selectKeys[reportTypeBean.id];
    LineChartData lidata = LineChartData(
      lineTouchData: LineTouchData(
          // touchSpotThreshold: 3,
          // enabled: false,
          // fullHeightTouchLine: true,
          touchCallback: (LineTouchResponse lineTouchResponse) {
            trendModel.showTouchCallback(
                lineTouchResponse, reportTypeBean, selectKeys, xTitles);
          },
          // getTouchedSpotIndicator:
          //     (LineChartBarData barData, List<int> spotIndexes) {
          //   return spotIndexes.map((spotIndex) {
          //     final FlSpot spot = barData.spots[spotIndex];
          //     // if (spot.x == 0 || spot.x == 6) {
          //     //   return null;
          //     // }
          //     return TouchedSpotIndicatorData(
          //       FlLine(color: Colors.blue, strokeWidth: 4),
          //       FlDotData(
          //         getDotPainter: (spot, percent, barData, index) {
          //           if (index % 2 == 0) {
          //             return FlDotCirclePainter(
          //                 radius: 8,
          //                 color: Colors.white,
          //                 strokeWidth: 5,
          //                 strokeColor: Colors.deepOrange);
          //           } else {
          //             return FlDotSquarePainter(
          //               size: 16,
          //               color: Colors.white,
          //               strokeWidth: 5,
          //               strokeColor: Colors.deepOrange,
          //             );
          //           }
          //         },
          //       ),
          //     );
          //   }).toList();
          // },
          touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: Colors.blueAccent,
              getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                return touchedBarSpots.map((barSpot) {
                  final flSpot = barSpot;
                  // if (flSpot.x == 0 || flSpot.x == 6) {
                  //   return null;
                  // }
                  return null;
                  // return LineTooltipItem(
                  //   '${[flSpot.x.toInt()]} \n${flSpot.y} k calories',
                  //   const TextStyle(color: Colors.white),
                  // );
                }).toList();
              })),
      gridData: FlGridData(
        show: false,
      ),

      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          textStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.normal,
            fontSize: 16,
          ),
          margin: 10,
          getTitles: (xvalue) {
            // return xTitles[xvalue.toInt()].toString();
            // print(xvalue);
            if (xvalue % 3 == 1 && xTitles[xvalue.toInt()] != null) {
              return xTitles[xvalue.toInt()].substring(0, 7);
            }
            return '';
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.normal,
            fontSize: 12,
          ),
          getTitles: (value) {
            if (selectKeys.length > 1) {
              switch (value.toInt()) {
                case 0:
                  return "阴性";
                case 1:
                  return '阳性±';
                case 2:
                  return '+';
                case 3:
                  return '++';
                case 4:
                  return '+++';
              }
            } else {
              if (reportTypeKeysBean.data_type == "1") {
                return reportTypeKeysBean.downList[value.toInt()];
              }

              return value.toString();
            }
          },
          margin: 10,
          reservedSize: 40,
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(
            color: Colors.white38,
            width: 0.5,
          ),
          left: BorderSide(
            color: Colors.white38,
            width: 0.5,
          ),
          right: BorderSide(
            color: Colors.transparent,
          ),
          top: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
      // minX: 0,
      // maxX: 14,

      lineBarsData: buildLinesBarData(trendModel),
    );

    if (selectKeys.length > 1) {
      lidata..maxY = 5;
      lidata..minY = 0;
    } else {
      if (reportTypeKeysBean != null && reportTypeKeysBean.data_type == "1") {
        lidata..maxY = (reportTypeKeysBean.downList.length - 1).toDouble();
        lidata..minY = 0;
      }
    }
    return lidata;
  }

  /**
   * 初始化x
   */
  buildXtitles(TrendModel trendModel) {
    List<int> selectKeys = trendModel.selectKeys[reportTypeBean.id];
    if (selectKeys == null || selectKeys.length == 0) return;

    selectKeys.forEach((element) {
      List<dynamic> reportKeyValue =
          trendModel.reportKeyValue["${reportTypeBean.id}_${element}"];
      if (reportKeyValue == null) return;
      reportKeyValue.forEach((data) {
        if (xTitles.indexOf(data['report_day']) == -1) {
          xTitles.add(data['report_day']);
        }
      });
    });
  }

  List<LineChartBarData> buildLinesBarData(TrendModel trendModel) {
    // List<dynamic> values
    List<LineChartBarData> datas = [];
    List<int> selectKeys = trendModel.selectKeys[reportTypeBean.id];
    if (selectKeys == null || selectKeys.length == 0) return datas;

    selectKeys.forEach((element) {
      List<dynamic> reportKeyValue =
          trendModel.reportKeyValue["${reportTypeBean.id}_${element}"];

      var keyIndex =
          reportTypeBean.reportTypeKeys.indexWhere((el) => el.id == element);

      if (reportKeyValue == null) return null;
      List<FlSpot> spots = [];
      reportKeyValue.forEach((data) {
        int index = xTitles.indexOf(data['report_day']);
        String value =
            selectKeys.length > 1 ? data['status'].toString() : data['value'];

        if (selectKeys.length == 1) {
          if (reportTypeKeysBean.data_type == "1") {
            //下拉处理
            value = data['status'].toString();
          }
        }

        spots.add(FlSpot(index.toDouble(), double.parse(value)));
      });

      if (spots.length == 0) return datas;

      datas.add(LineChartBarData(
        // dashArray: [0, 1, 2, 3, 4, 5],
        spots: spots,
        // isCurved: true,
        colors: [
          lineColors[keyIndex]
          // Colors.primaries[Random().nextInt(Colors.primaries.length)]
          // const Color(0xff4af699),
        ],
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: false,
        ),
        belowBarData: BarAreaData(
          show: false,
        ),
      ));
    });

    return datas;
  }

  // void _showMultiSelectDialog(
  //     BuildContext context, TrendModel trendModel) async {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         elevation: 4,
  //         title: Text("选择要的指标"),
  //         content: StatefulBuilder(
  //             builder: (BuildContext context, StateSetter setState) {
  //           List<int> selKeys = trendModel.selectKeys[reportTypeBean.id];
  //           selKeys = selKeys == null ? [] : selKeys;
  //           return Container(
  //               height: 300,
  //               child: SingleChildScrollView(
  //                 child: Column(
  //                   children: <Widget>[
  //                     ...reportTypeBean.reportTypeKeys.map((e) => InkWell(
  //                         onTap: () {
  //                           bool checked = !selKeys.contains(e.id);
  //                           // if (checked) {
  //                           //   selKeys.add(e.id);
  //                           // } else {
  //                           //   selKeys.remove(e.id);
  //                           // }
  //                           trendModel.choseKeyDot(
  //                               checked, e.id, reportTypeBean.id);
  //                           setState(() {});
  //                         },
  //                         child: Row(
  //                           children: <Widget>[
  //                             Checkbox(
  //                               value: selKeys.contains(e.id),
  //                               onChanged: (value) {
  //                                 trendModel.choseKeyDot(
  //                                     value, e.id, reportTypeBean.id);
  //                                 // if (value) {
  //                                 //   selKeys.add(e.id);
  //                                 // } else {
  //                                 //   selKeys.remove(e.id);
  //                                 // }
  //                                 setState(() {});
  //                               },
  //                             ),
  //                             Text(e.name)
  //                           ],
  //                         )))
  //                   ],
  //                 ),
  //               ));
  //         }),
  //         actions: <Widget>[
  //           // FlatButton(
  //           //     onPressed: () {
  //           //       Navigator.of(context).pop();
  //           //       trendModel.cancleChose(reportTypeBean.id);
  //           //     },
  //           //     child: Text(
  //           //       "取消",
  //           //       style: TextStyle(color: Colors.grey),
  //           //     )),

  //           FlatButton(
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //                 trendModel.submitChose(reportTypeBean.id);
  //               },
  //               child: Text(
  //                 "关闭",
  //                 style: TextStyle(color: Colors.redAccent),
  //               )),
  //         ],
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    TrendModel model = Provider.of<TrendModel>(context);
    final size = MediaQuery.of(context).size;
    List<ReportTypeKeysBean> kesBeans = [];
    List<int> selectKeys = model.selectKeys[reportTypeBean.id];
    if (selectKeys != null) {
      selectKeys.forEach((element) {
        // if (subKeyTitle != null && subKeyTitle != "") {
        //   subKeyTitle = subKeyTitle + "&";
        // }
        kesBeans
            .add(model.reportTypeKeyBean["${reportTypeBean.id}_${element}"]);
        // subKeyTitle = subKeyTitle +
        //     model.reportTypeKeyBean["${reportTypeBean.id}_${element}"].name;
      });
    }

    if (selectKeys.length == 1) {
      reportTypeKeysBean =
          model.reportTypeKeyBean["${reportTypeBean.id}_${selectKeys[0]}"];
    }

    buildXtitles(model);
    List<ReportTypeKeysBean> list = [];
    reportTypeBean.reportTypeKeys.forEach((element) {
      if (element.in_chart == "1") {
        list.add(element);
      }
    });

    return AspectRatio(
      aspectRatio: 1.33,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        color: Colors.transparent,
        shadowColor: Colors.transparent,
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: const Color(0xff0f4a3c),
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  SizedBox(
                    height: 40,
                    child: SingleChildScrollView(
                        child: Row(
                          children: <Widget>[
                            Tags(
                              itemCount: list.length,
                              itemBuilder: (int index) {
                                return Tooltip(
                                    message: list[index].name,
                                    child: ItemTags(
                                      elevation: 1,
                                      index: index,
                                      onPressed: (i) {
                                        bool checked = selectKeys
                                                .indexOf(list[index].id) !=
                                            -1;
                                        model.choseKeyDot(
                                            !checked,
                                            list[index].id,
                                            list[index].report_type_id);
                                      },
                                      active:
                                          selectKeys.indexOf(list[index].id) !=
                                              -1,
                                      activeColor: lineColors[index],
                                      title: list[index].name,
                                    ));
                              },
                            )
                          ],
                        ),
                        scrollDirection: Axis.horizontal),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                          width: xTitles.length * 30 > size.width
                              ? xTitles.length * 30.toDouble()
                              : null,

                          // xTitles.length *
                          //     (xTitles.length < 5 ? 80 : 30).toDouble(),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4.0, vertical: 10),
                          child: selectKeys != null && selectKeys.length > 0
                              ? LineChart(
                                  getChartData(model),
                                  swapAnimationDuration: animDuration,
                                )
                              : Container()),
                    ),
                  ),
                ],
              ),
            ),
            // Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: Align(
            //       alignment: Alignment.topRight,
            //       child: IconButton(
            //         icon: Icon(Icons.list),
            //         onPressed: () {
            //           this._showMultiSelectDialog(context, model);
            //         },
            //       ),
            //     )),
          ],
        ),
      ),
    );
  }
}
