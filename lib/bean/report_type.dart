import 'package:medical/bean/report_type_keys.dart';

/**
 * 报告单实例
 */
class ReportTypeBean {
  String name;
  int id;
  String short_name;
  String desc;
  List<ReportTypeKeysBean> reportTypeKeys;

  static ReportTypeBean fromMap(Map<String, dynamic> map) {
    ReportTypeBean reportBean = new ReportTypeBean();
    reportBean.name = map['name'];
    reportBean.id = map['id'];
    reportBean.short_name = map['short_name'];
    reportBean.desc = map['desc'];
    reportBean.reportTypeKeys = ReportTypeKeysBean.fromMapList(map['meta']);
    return reportBean;
  }

  static List<ReportTypeBean> fromMapList(dynamic mapList) {
    List<ReportTypeBean> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }
}
