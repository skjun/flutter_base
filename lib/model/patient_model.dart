import 'package:flutter/material.dart';
import 'package:medical/api/api_service.dart';
import 'package:medical/bean/patients.dart';
import 'package:medical/model/global_model.dart';
import 'package:medical/utils/toast_util.dart';

class PatientPageModel extends ChangeNotifier {
  PatientPageModel(old) {
    this.oldPatient = old == null ? new Patients() : old;
  }

  BuildContext context;
  Color customColor = Colors.black;

  Patients oldPatient;

  String currentTaskName = "";
  GlobalModel globalModel;

  void setContext(BuildContext context, {GlobalModel gl}) {
    if (this.context == null) {
      this.context = context;
    }
    this.globalModel = gl;
  }

  void setValue(key, value) {
    if (key == "sex") {
      oldPatient.sex = value;
    }
    if (key == "name") {
      oldPatient.name = value;
    }
    if (key == "birth") {
      oldPatient.birth = value;
    }

    refresh();
  }

  ///表示当前是属于创建新的任务还是修改旧的任务
  bool isEditOldTask() {
    return oldPatient != null && oldPatient.id != null;
  }

  String getHintTitle() {
    bool isEdit = isEditOldTask();
    return isEdit ? "修改" : "新增";
  }

  void onSubmitTap(context) {
    if (oldPatient.name == null ||
        oldPatient.name == "" ||
        oldPatient.name.length == 0 ||
        oldPatient.name.length > 3) {
      ToastUtil().showError("请输入姓名,最大长度为3");
      return;
    }

    if (oldPatient.birth == null) {
      ToastUtil().showError("请输入出生年月");
      return;
    }
    Map<String, String> params = {
      "name": oldPatient.name,
      "id": oldPatient.id.toString(),
      "sex": oldPatient.sex == null ? "男" : oldPatient.sex,
      "birth": oldPatient.birth
    };
    ApiService().savePatients(
        params: params,
        success: (data) {
          ToastUtil().showSuccess(data);
          globalModel.loadPatients();
          Navigator.pop(context);
        });
  }

  @override
  void dispose() {
    super.dispose();
    debugPrint("ThemePageModel销毁了");
  }

  void refresh() {
    notifyListeners();
  }
}
