import 'package:medical/model/global_model.dart';

/**
 * 全局数据
 */
class GlobalUtil {
  static GlobalUtil _instance;

  static GlobalUtil getInstance() {
    if (_instance == null) {
      _instance = GlobalUtil._internal();
    }
    return _instance;
  }

  GlobalUtil._internal();

  /**
   * 全局token
   */
  String token;

  GlobalModel globalModel;
}
