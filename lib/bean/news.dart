/**
 * 病人信息
 */
class News {
  String title;
  int id;
  String short_content;
  String load_img;
  String created_at;
  String post_content;
  static News fromMap(Map<String, dynamic> map) {
    News news = new News();
    news.title = map['title'];
    news.id = map['id'];
    news.short_content = map['short_content'];
    news.load_img = map['load_img'];
    news.created_at = map['created_at_tran'];
    news.post_content = map['post_content'];
    return news;
  }

  static List<News> fromMapList(dynamic mapList) {
    List<News> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }
}
