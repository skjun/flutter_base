class ReportValueBean {
  int patient_report_id;
  int report_type_id;
  int report_type_key_id;
  String value;
  String user_value;
  int status;

  String short_name;
  String right;

  static ReportValueBean fromMap(Map<String, dynamic> map) {
    ReportValueBean reportValueBean = new ReportValueBean();
    reportValueBean.patient_report_id = map['patient_report_id'];
    reportValueBean.report_type_id = map['report_type_id'];
    reportValueBean.report_type_key_id = map['report_type_key_id'];
    reportValueBean.value = map['value'];
    reportValueBean.user_value = map['user_value'];
    reportValueBean.status = map['status'];
    reportValueBean.short_name = map['short_name'];
    reportValueBean.right = map['right'];
    return reportValueBean;
  }

  static List<ReportValueBean> fromMapList(dynamic mapList) {
    List<ReportValueBean> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }
}
