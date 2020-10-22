import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:medical/api/api_service.dart';
import 'package:medical/bean/report_type.dart';
import 'package:medical/bean/report_type_keys.dart';
import 'package:medical/bean/report_value_bean.dart';
import 'package:medical/model/global_model.dart';
import 'package:medical/pages/widgets/numberformat.dart';
import 'package:medical/utils/event_center.dart';

class TrendModel extends ChangeNotifier {
  GlobalModel globalModel;

  NumberFormat numberFormat;

  BuildContext context;

  List<ReportTypeBean> repostTypes = [];

  Map<int, ReportTypeBean> reportTypeBean = {};
  Map<String, ReportTypeKeysBean> reportTypeKeyBean = {};

  /**
   * 指标对应节点选择的数据列表
   * reportTypeId,
   * List<int> , 选中的 id列表
   */
  Map<int, List<int>> selectKeys = {};
  /**
   * report_key values
   * key: reportId_keyId
   * value: list Map 数据
   */
  Map<String, List<dynamic>> reportKeyValue = {};

  bool showDetail = false;
  bool pleft = true;
  /**
   * 节点数据
   */
  List<LineBarSpot> lineBarSpots;

  ReportTypeBean currentShowReportTypeBean;

  List<ReportValueBean> tipdatas = [];

  double width;

  /**
   * 构造函数
   */
  TrendModel() {
    eventCenter.on("changePatient", (e) {
      getReportTypes();
    });
  }

  void setContext(BuildContext context, {GlobalModel gl}) {
    this.globalModel = gl;
    if (this.context == null) {
      this.context = context;
      getReportTypes();
    }
  }

  void setSize(s) {
    width = s;
  }

  /**
   * 设置选中
   */
  void choseKeyDot(value, keyId, reportId) {
    List<int> tkeys = selectKeys[reportId];
    print("choseKeyDot:${value} -${keyId}-${tkeys}");
    if (value) {
      //勾选
      if (!tkeys.contains(keyId)) {
        tkeys.add(keyId);

        ReportTypeKeysBean rtkb = reportTypeKeyBean["${reportId}_${keyId}"];
        this.getPatientTrendKey(rtkb.report_type_id, rtkb.id);
      }
    } else {
      if (tkeys.contains(keyId)) {
        tkeys.remove(keyId);
      }
    }
    selectKeys[reportId] = tkeys;
    refresh();
  }

  submitChose(rid) {
    refresh();
  }

  /**
   * 
   */
  showTouchCallback(
      LineTouchResponse lineTouchResponse,
      ReportTypeBean reportTypeBean,
      List<int> selectKeys,
      List<String> xTitles) {
    tipdatas = [];
    currentShowReportTypeBean = reportTypeBean;
    if (lineTouchResponse == null) {
      showDetail = false;
      refresh();
      return;
    }
    //
    if (lineTouchResponse.isFinish) {
      showDetail = false;
    } else {
      showDetail = true;
    }

    if (lineTouchResponse.lineBarSpots == null ||
        lineTouchResponse.lineBarSpots.length == 0) {
      showDetail = false;
    }
    lineBarSpots = lineTouchResponse.lineBarSpots;
    if (lineBarSpots == null) {
      refresh();
      return;
    }
    int barIndex;
    lineBarSpots.forEach((barspot) {
      // print(barspot.spotIndex);
      barIndex = barspot.spotIndex;
    });

    if (barIndex == null) {
      refresh();
      return;
    }

    selectKeys.forEach((element) {
      var dotValue =
          reportKeyValue["${currentShowReportTypeBean.id}_${element}"];
      String xlabel = xTitles[barIndex];
      var kevalue =
          dotValue.firstWhere((element) => element['report_day'] == xlabel);

      if (kevalue != null) {
        var report_type_key_id = kevalue['report_type_key_id'];
        ReportTypeKeysBean reportTb =
            reportTypeKeyBean["${reportTypeBean.id}_${report_type_key_id}"];
        ReportValueBean reportValueBean = new ReportValueBean();
        reportValueBean.short_name = reportTb.short_name;
        reportValueBean.user_value = kevalue['user_value'];
        reportValueBean.status = kevalue['status'];
        tipdatas.add(reportValueBean);
      }
    });

    pleft = lineTouchResponse.touchInput.getOffset().dx > width / 2;
    refresh();
  }

  /**
   * 获取报告单下拉列表数据
   */
  getReportTypes() {
    selectKeys = {};
    reportKeyValue = {};
    ApiService().getReportTypes(
        params: {"patient_id": globalModel.currentPatient.id.toString()},
        success: (data) {
          if (data == null) return;
          repostTypes = data;
          refresh();
          repostTypes.forEach((element) {
            reportTypeBean[element.id] = element;
            element.reportTypeKeys.forEach((kel) {
              reportTypeKeyBean["${element.id}_${kel.id}"] = kel;
            });

            //默认加载第一个指标趋势信息
            ReportTypeKeysBean first = element.reportTypeKeys.first;

            List<int> kvals = selectKeys[element.id];

            if (kvals == null) {
              kvals = [];
            }
            if (kvals.indexOf(first.id) == -1) {
              kvals.add(first.id);
            }
            selectKeys[element.id] = kvals;

            getPatientTrendKey(element.id, first.id);
          });
        });
  }

  getPatientTrendKey(int report_type_id, int report_type_key_id) {
    var ldata = reportKeyValue["${report_type_id}_${report_type_key_id}"];
    if (ldata != null && ldata.length > 0) {
      return;
    }
    Map<String, String> pms = {
      "patient_id": globalModel.currentPatient.id.toString(),
      "report_type_id": report_type_id.toString(),
      "report_type_key_id": report_type_key_id.toString()
    };
    ApiService().getPatientTrend(
        params: pms,
        success: (data) {
          if (data != null) {
            reportKeyValue["${report_type_id}_${report_type_key_id}"] = data;
          }
          refresh();
        },
        error: () {});
  }

  getDropWidgets(List<ReportTypeKeysBean> reportTypeKeysBean) {
    List<DropdownMenuItem<int>> dchilds = [];
    if (reportTypeKeysBean.length > 0) {
      reportTypeKeysBean.forEach((element) {
        dchilds.add(new DropdownMenuItem(
          child: new Text(element.name),
          value: element.id,
        ));
      });
    }
    return dchilds;
  }

  @override
  void dispose() {
    super.dispose();
    selectKeys = {};
    reportKeyValue = {};
    debugPrint("TrendModel销毁了");
    eventCenter.off("changePatient", (e) {});
  }

  void refresh() {
    notifyListeners();
  }
}
