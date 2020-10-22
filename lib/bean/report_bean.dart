import 'package:medical/bean/report_value_bean.dart';

/**
 * 报告单
 */
class ReportBean {
  String reportTypeName;

  String filePath;
  String testName;

  String reportDay;
  int userId;

  int patientId;
  int reportTypeId;
  int id;

  String age;

  List<ReportValueBean> reportValue;

  static ReportBean fromMap(Map<String, dynamic> map) {
    ReportBean reportBean = new ReportBean();
    reportBean.filePath = map['file_path'];
    reportBean.testName = map['test_name'];

    reportBean.reportDay = map['report_day'];
    reportBean.userId = map['user_id'];
    reportBean.patientId = map['patient_id'];
    reportBean.reportTypeId = map['report_type_id'];
    reportBean.reportTypeName = map['reportTypeName'];
    reportBean.id = map['id'];

    reportBean.age = map['age'];

    reportBean.reportValue = ReportValueBean.fromMapList(map['reportValue']);
    return reportBean;
  }

  static List<ReportBean> fromMapList(dynamic mapList) {
    List<ReportBean> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }
}
