class LoginBean {
  String description;
  int id;
  String token;
  String mobile;
  String photo_url;

  static LoginBean fromMap(Map<String, dynamic> map) {
    LoginBean loginBean = new LoginBean();
    loginBean.id = map['id'];
    loginBean.token = map['token'];
    loginBean.mobile = map['mobile'];
    loginBean.photo_url = map['photo_url'];
    return loginBean;
  }

  static List<LoginBean> fromMapList(dynamic mapList) {
    List<LoginBean> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }
}
