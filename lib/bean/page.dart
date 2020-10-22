/**
 * 病人信息
 */
class PageVo {
  int totalpage;
  int total;
  int curpage;
  int last_id;
  List<dynamic> datas;

  static PageVo fromMap(Map<String, dynamic> map) {
    PageVo page = new PageVo();
    page.total = map['total'];
    page.totalpage = map['totalpage'];
    page.curpage = map['curpage'];
    page.datas = map['datas'];
    page.last_id = map['last_id'];
    return page;
  }
}
