import 'package:flutter/material.dart';
import 'package:medical/api/api_service.dart';
import 'package:medical/api/keys.dart';
import 'package:medical/bean/report_bean.dart';
import 'package:medical/bean/report_type.dart';
import 'package:medical/bean/report_type_keys.dart';
import 'package:medical/model/global_model.dart';
import 'package:medical/pages/widgets/numberformat.dart';
import 'package:medical/utils/event_center.dart';
import 'package:medical/utils/provider_config.dart';
import 'package:medical/utils/toast_util.dart';

class ReportModel extends ChangeNotifier {
  GlobalModel globalModel;

  NumberFormat numberFormat;

  BuildContext context;

  ReportBean reportBean;

  List<ReportTypeBean> repostTypes = [];

  ReportTypeBean currentReportType;

  Map<int, String> reportValue = {};

  bool isEdit = false;

  /**
   * 构造函数
   */
  ReportModel(ReportBean inBean) {
    reportBean = inBean == null ? new ReportBean() : inBean;

    if (inBean != null) {
      isEdit = true;
    }
    getReportTypes();
    numberFormat = new NumberFormat(decimalRange: 3);
    refresh();

    EventCenter().on(Keys.updateReportSuccess, (e) {
      getReportTypes();
    });
  }

  setReportType(id) {
    reportValue = {};
    currentReportType =
        repostTypes.firstWhere((element) => element.id == id, orElse: null);
    updateMetaValue();
    refresh();
  }

  void setContext(BuildContext context, {GlobalModel gl}) {
    if (this.context == null) {
      this.context = context;
    }
    this.globalModel = gl;
  }

  setValue(key, value) {
    if (key == "reportDay") {
      reportBean.reportDay = value;
    }
    if (key == "testName") {
      reportBean.testName = value;
    }
    refresh();
  }

  void onSubmitTap(context) {
    String reportValues = getRepValueStr();
    //保存数据
    Map<String, String> params = {
      "patient_id": globalModel.currentPatient.id == null
          ? ""
          : globalModel.currentPatient.id.toString(),
      "report_id": reportBean.id == null ? "" : reportBean.id.toString(),
      "reportDay": reportBean.reportDay,
      "report_type_id":
          currentReportType.id == null ? "" : currentReportType.id.toString(),
      "test_name": reportBean.testName,
      "reportValues": reportValues
    };
    ApiService().saveReport(
        params: params,
        success: (data) {
          ToastUtil().showSuccess(data);
          globalModel.loadReports();
          Navigator.pop(context);
        });
  }

  getRepValueStr() {
    String rvale = "";
    reportValue.forEach((key, value) {
      if (rvale != "") rvale += ",";
      rvale += "${key}=${value}";
    });
    return rvale;
  }

  /**
   * 获取报告单下拉列表数据
   */
  getReportTypes() {
    ApiService().getReportTypes(success: (data) {
      repostTypes = data;
      if (repostTypes != null && repostTypes.length > 0) {
        if (reportBean == null || reportBean.id == null) {
          currentReportType = repostTypes[0];
        } else {
          currentReportType = repostTypes.firstWhere(
              (element) => element.id == reportBean.reportTypeId,
              orElse: null);
        }
        updateMetaValue();
        refresh();
      }
    });
  }

  jumpSetting() {
    Navigator.pop(context);

    EventCenter().trigger(Keys.openEditor, currentReportType.id);
  }

  updateMetaValue() {
    if (currentReportType != null && currentReportType.reportTypeKeys != null) {
      currentReportType.reportTypeKeys.forEach((element) {
        if (!reportValue.containsKey(element.id)) {
          reportValue[element.id] = element.defaultVal;
        }
      });
    }
    if (reportBean != null && reportBean.reportValue != null) {
      reportBean.reportValue.forEach((element) {
        reportValue[element.report_type_key_id] = element.user_value;
      });
    }
  }

  getReportTypeWidgets() {
    List<DropdownMenuItem<int>> childs = [];
    if (repostTypes.length > 0) {
      repostTypes.forEach((element) {
        childs.add(new DropdownMenuItem(
          child: new Text(
            element.name,
            textAlign: TextAlign.center,
          ),
          value: element.id,
        ));
      });
    }
    return childs;
  }

  getDropWidgets(ReportTypeKeysBean reportTypeKeysBean) {
    List<DropdownMenuItem<String>> dchilds = [];
    if (reportTypeKeysBean.downList.length > 0) {
      reportTypeKeysBean.downList.forEach((element) {
        dchilds.add(new DropdownMenuItem(
          child: new Text(element),
          value: element,
        ));
      });
    }
    return dchilds;
  }

  /**
   * 保存数据
   */
  setReportValue(int id, String value) {
    reportValue[id] = value;
    refresh();
  }

  /**
   * 显示报告单明细
   */
  getReportMetaWidgets() {
    List<Widget> childs = [];
    if (currentReportType != null && currentReportType.reportTypeKeys != null) {
      currentReportType.reportTypeKeys.forEach((element) {
        childs.add(Padding(
          padding: EdgeInsets.only(left: 40, right: 40, top: 5),
          child: Row(
            children: <Widget>[
              Expanded(
                  flex: 3,
                  child: Container(
                    padding: EdgeInsets.only(right: 20),
                    child: Text(
                      "${element.short_name}(参考:${element.right}):",
                      style: TextStyle(),
                      textAlign: TextAlign.left,
                    ),
                  )),
              Expanded(
                  flex: 2,
                  child: Center(
                      // padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                      // height: 35,
                      // decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(8.0),
                      //     border: Border.all(color: Color(0xffe5e5e5))),
                      child: element.data_type == "1"
                          ? DropdownButtonHideUnderline(
                              child: DropdownButton(
                              items: getDropWidgets(element),
                              hint: new Text('请选择'),
                              onChanged: (value) {
                                setReportValue(element.id, value);
                              },
                              iconEnabledColor: Colors.black,
                              value: reportValue[element.id],
                              // value: model.oldPatient.sex == null
                              //     ? "男"
                              //     : model.oldPatient.sex,
                              elevation: 1, //设置阴影的高度
                              style: new TextStyle(
                                //设置文本框里面文字的样式
                                color: Colors.black,
                                fontSize: 16,
                              ),

//              isDense: false,//减少按钮的高度。默认情况下，此按钮的高度与其菜单项的高度相同。如果isDense为true，则按钮的高度减少约一半。 这个当按钮嵌入添加的容器中时，非常有用
                              iconSize: 30.0,
                            ))
                          : TextFormField(
                              onChanged: (value) {
                                value = numberFormat.getFormatData(value);
                                if (value != null) {
                                  setReportValue(element.id, value);
                                }
                              },
                              autofocus: false,
                              controller: new TextEditingController.fromValue(
                                  new TextEditingValue(
                                      text: reportValue[element.id] ?? "",
                                      selection: new TextSelection.collapsed(
                                          offset:
                                              reportValue[element.id] == null
                                                  ? 0
                                                  : reportValue[element.id]
                                                      .length))),
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              inputFormatters: [numberFormat],
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xffe5e5e5)),
                                    borderRadius: BorderRadius.circular(8.0)),
                              ),
                            )))
            ],
          ),
        ));
      });
    }
    return childs;
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
