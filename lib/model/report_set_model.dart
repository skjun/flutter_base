import 'package:flutter/material.dart';
import 'package:medical/api/api_service.dart';
import 'package:medical/api/keys.dart';
import 'package:medical/bean/report_bean.dart';
import 'package:medical/bean/report_type.dart';
import 'package:medical/bean/report_type_keys.dart';
import 'package:medical/model/global_model.dart';
import 'package:medical/utils/event_center.dart';
import 'package:medical/utils/toast_util.dart';

class ReportSetModel extends ChangeNotifier {
  GlobalModel globalModel;

  BuildContext context;

  ReportBean reportBean;

  int report_id;

  List<ReportTypeBean> repostTypes = [];

  List<ReportTypeKeysBean> reportKeys = [];

  List<int> showIDs = [];

  /**
   * 构造函数
   */
  ReportSetModel(int report) {
    report_id = report;

    if (report_id == null) {
      getReportTypes();
    } else {
      getReportTypeKeys();
    }

    refresh();
  }

  void setContext(BuildContext context, {GlobalModel gl}) {
    if (this.context == null) {
      this.context = context;
    }
    this.globalModel = gl;
  }

  /**
   * 获取报告单下拉列表数据
   */
  getReportTypes() {
    ApiService().getReportTypes(success: (data) {
      repostTypes = data;
      if (repostTypes != null && repostTypes.length > 0) {
        refresh();
      }
    });
  }

  getReportTypeKeys() {
    showIDs = [];
    ApiService().getUserReportKeys(
        params: {"report_type_id": report_id.toString()},
        success: (data) {
          reportKeys = data;

          reportKeys.forEach((element) {
            if (element.inflag > 0) {
              showIDs.add(element.id);
            }
          });
          if (reportKeys != null && reportKeys.length > 0) {
            refresh();
          }
        });
  }

  swapList(before, after) {
    List<ReportTypeKeysBean> list = reportKeys.toList();
    ReportTypeKeysBean item = list[before];
    list.removeAt(before);
    list.insert(after, item);
    reportKeys = list;
    refresh();
  }

  updateSelect(id, value) {
    if (value) {
      if (showIDs.indexOf(id) == -1) {
        showIDs.add(id);
      }
    } else {
      showIDs.remove(id);
    }
    refresh();
  }

  /**
   * 提交保存数据
   */
  subMit() {
    var listShow = [];
    reportKeys.forEach((element) {
      if (showIDs.indexOf(element.id) != -1) {
        listShow.add(element.id);
      }
    });

    var idstr = listShow.join(",");
    var param = {"report_type_id": report_id.toString(), "ids": idstr};

    ApiService().saveReportValue(
        params: param,
        success: (data) {
          if (data != null) {
            ToastUtil().showSuccess("修改成功");
            EventCenter().trigger(Keys.updateReportSuccess);
          }
        });
  }

  @override
  void dispose() {
    super.dispose();
    debugPrint("ReportModel销毁了");
  }

  void refresh() {
    notifyListeners();
  }
}
