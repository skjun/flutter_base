class ReportTypeKeysBean {
  int report_type_id;
  int id;
  String name;
  String short_name;
  String desc;
  int show_index;

  /**
   * 类型, 0:数字,1:下拉框
   */
  String data_type;

  /**
   * 参考值
   */
  String right;
  /**
   * 参考显示
   */
  String data_typeright;
  /**
   * 下拉显示范围
   */
  String data_format;

  List<String> downList;

  String defaultVal;

  String in_chart;

  /**
   * 指标对应的数据列表. key为日期,num为具体数值
   */
  List<Map<String, num>> datas;

  /**
   * 是否被使用
   */
  int inflag;

  String unit;
  static ReportTypeKeysBean fromMap(Map<String, dynamic> map) {
    ReportTypeKeysBean reportBean = new ReportTypeKeysBean();
    reportBean.report_type_id = map['report_type_id'];
    reportBean.id = map['id'];
    reportBean.name = map['name'];
    reportBean.short_name = map['short_name'];
    reportBean.right = map['right'];
    reportBean.data_type = map['data_type'];
    reportBean.data_format = map['data_format'];
    reportBean.defaultVal = map['default'];
    reportBean.in_chart = map['in_chart'];

    reportBean.inflag = map['inflag'];

    reportBean.unit = map['unit'];
    if (reportBean.data_type == "1" && reportBean.data_format != null) {
      reportBean.downList = reportBean.data_format.split(";");
    }

    return reportBean;
  }

  static List<ReportTypeKeysBean> fromMapList(dynamic mapList) {
    List<ReportTypeKeysBean> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }
}
