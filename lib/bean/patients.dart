/**
 * 病人信息
 */
class Patients {
  String name;
  int id;
  String photo;
  String sex;
  String birth;
  int userid;
  String age;

  static Patients fromMap(Map<String, dynamic> map) {
    Patients patients = new Patients();
    patients.name = map['name'];
    patients.id = map['id'];
    patients.photo = map['photo'];
    patients.sex = map['sex'];
    patients.birth = map['birth'];
    patients.age = map['age'];
    return patients;
  }

  static List<Patients> fromMapList(dynamic mapList) {
    List<Patients> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }
}
