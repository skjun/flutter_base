import 'package:flutter/material.dart';

import 'package:medical/api/api_service.dart';
import 'package:medical/api/keys.dart';
import 'package:medical/bean/color_bean.dart';
import 'package:medical/bean/login_bean.dart';
import 'package:medical/bean/patients.dart';
import 'package:medical/bean/report_bean.dart';
import 'package:medical/bean/report_type.dart';
import 'package:medical/bean/theme_bean.dart';
import 'package:medical/pages/widgets/net_loading_widget.dart';
import 'package:medical/utils/event_center.dart';
import 'package:medical/utils/global_uitl.dart';
import 'package:medical/utils/provider_config.dart';
import 'package:medical/utils/shared_util.dart';
import 'package:medical/utils/theme_util.dart';
import 'package:medical/pages/login/style/theme.dart' as mainTheme;

class GlobalModel extends ChangeNotifier {
  BuildContext context;

  ///GlobalModel可以用来统一管理所有的model，这里只管理了一部分
  ///
  ///
  ///
  LoginBean loginBean;

  bool checkLogin = false;

  ///app的名字
  String appName = '一日';

  ///当前的主题颜色数据
  ThemeBean currentThemeBean = ThemeBean(
    themeName: 'pink',
    colorBean: ColorBean.fromColor(MyThemeColor.defaultColor),
    themeType: MyTheme.defaultTheme,
  );

  Color backColor = Colors.cyan[100];
  Color footColor = mainTheme.Colors.loginGradientEnd;

  ///是否开启自动夜间模式
  bool enableAutoDarkMode = false;

  ///当前自动夜间模式，白天的时间区间,比如：'7/20'
  String autoDarkModeTimeRange = '';

  ///当前语言
  List<String> currentLanguageCode = ['zh', 'CN'];
  String currentLanguage = '中文';
  Locale currentLocale;

  /**
   * 是否开启loading页面
   */
  bool showLoading = false;

  ///设置页面，用于loading加载框
  LoadingController loadingController = LoadingController();

  //用户信息

  List<Patients> patients = [];

  Patients currentPatient;
  /**
   * 当前用户的报告单数据列表
   */
  List<ReportBean> reports = [];

  /**
   * 用户报告单类型列表
   */
  List<ReportTypeBean> userReportTypes = [];
  /**
   * 默认选择全部
   */
  int currentReportTypeId = 0;
  void setContext(BuildContext context) {
    if (this.context == null) {
      this.context = context;

      Future.wait([
        //加载loading状态
        getLoadingStatus(),

        //加载登录状态
        getLoginStatus(),
        //加载默认保存主题
        getCurrentLanguageCode(),
        getCurrentLanguage()
      ]).then((value) {
        chooseTheme();
        currentLocale = Locale(currentLanguageCode[0], currentLanguageCode[1]);
        refresh();
      });

      print("wait end");
    }
  }

  void setPageModel() {
    debugPrint("设置taskDetailPageModel");
  }

  void firstVisedEnd(context) {
    setLoadedStatus();

    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return ProviderConfig.getInstance().getMainLogin();
    }));
  }

  /**
   * 设置用户信息数据
   * 唯一入口
  */
  void setUser(user) {
    loginBean = user;
    refresh();
    //加载用户病人数据
    loadPatients();

    // loadUserReportTypes();
  }

  /**
   * 设置当前显示的报告单列表
   */
  void setCurReportType(int typeId) {
    currentReportTypeId = typeId;
    refresh();
  }

  /**
   * 设置用户信息数据
   * 唯一入口
  */
  void loadUserReportTypes() {
    userReportTypes = [];

    ReportTypeBean rp = new ReportTypeBean();
    rp.name = "全部";
    rp.id = 0;
    userReportTypes.add(rp);
    if (currentPatient != null) {
      Map<String, String> params = {"patient_id": currentPatient.id.toString()};
      ApiService().getReportTypes(
          params: params,
          success: (data) {
            userReportTypes.addAll(data);
            refresh();
          });
    }
  }

  /**
   * 获取用户报告单数据
   */
  void loadReports() {
    if (currentPatient != null) {
      Map<String, String> params = {"patient_id": currentPatient.id.toString()};
      ApiService().getReports(
          params: params,
          success: (data) {
            reports = data;
            refresh();
          });
    }
  }

  void deleteReport(ReportBean reportBean) {
    ApiService().deleteReport(
        params: {'report_id': reportBean.id.toString()},
        success: (data) {
          loadReports();
        },
        error: (e) {});
  }

  void setCurrentPatient(Patients patients) {
    if (currentPatient.id != patients.id) {
      currentPatient = patients;
      loadReports();

      eventCenter.trigger("changePatient");
    }
  }

  void loadPatients() {
    ApiService().getPatients(success: (data) {
      patients = Patients.fromMapList(data);
      if (patients != null && patients.length > 0) {
        if (currentPatient != null) {
          currentPatient = patients
              .firstWhere((el) => el.id == currentPatient.id, orElse: null);
          if (currentPatient == null) currentPatient = patients[0];
        } else {
          currentPatient = patients[0];
        }
      } else {
        currentPatient = null;
      }
      //加载用户报告单数据
      loadReports();
      loadUserReportTypes();
      refresh();
    });
  }

  Future setLoadedStatus() async {
    showLoading = false;
    await SharedUtil.instance.saveGlobalString(Keys.firstInstall, "1");
    loginBean = null;
    notifyListeners();
  }

  /**
      * 第一次状态 
      */
  Future getLoadingStatus() async {
    final firstInstall =
        await SharedUtil.instance.getGlobalString(Keys.firstInstall);
    if (firstInstall == null) showLoading = true;
    refresh();
  }

  /**
      * 获取登录状态 
      */
  Future getLoginStatus() async {
    final token = await SharedUtil.instance.getGlobalString(Keys.token);
    GlobalUtil.getInstance().token = token;
    ApiService.instance.info(success: (data) {
      if (data == 401) {
        // SharedUtil.instance.saveGlobalString(Keys.token, null);
        EventCenter().trigger(Keys.needLogin);
        // GlobalUtil.getInstance().token = null;
      } else {
        dealLoginSuccess(data);
      }
    }, error: (err) {
      SharedUtil.instance.saveGlobalString(Keys.token, null);
    });
  }

  /**
       * 退出登录
       */
  loginOut() {
    ApiService.instance.logout(
        success: (data) {
          SharedUtil.instance.saveGlobalString(Keys.token, null);
          GlobalUtil.getInstance().token = null;
          setUser(null);
          refresh();
          EventCenter().trigger(Keys.needLogin);
          currentPatient = null;
          reports = [];
        },
        error: (err) {});
  }

  dealLoginSuccess(data) {
    SharedUtil.instance.saveGlobalString(Keys.token, data.token);
    setUser(data);
    GlobalUtil.getInstance().token = data.token;
  }

  ///获取当前的语言code
  Future getCurrentLanguageCode() async {
    final list =
        await SharedUtil.instance.getStringList(Keys.currentLanguageCode);
    if (list == null) return;
    if (list == currentLanguageCode) return;
    currentLanguageCode = list;
  }

  ///获取当前的语言
  Future getCurrentLanguage() async {
    final currentLanguage =
        await SharedUtil.instance.getString(Keys.currentLanguage);
    if (currentLanguage == null) return;
    if (currentLanguage == this.currentLanguage) return;
    this.currentLanguage = currentLanguage;
  }

  ///根据数据来决定显示什么主题
  void chooseTheme() {
    if (this.enableAutoDarkMode) return;
    if (this.autoDarkModeTimeRange.isEmpty) return;
    final times = this.autoDarkModeTimeRange.split('/');
    if (times.length < 2) return;
    final start = int.parse(times[0]);
    final end = int.parse(times[1]);
    final time = DateTime.now();
    if (time.hour < start || time.hour > end) {
      final String languageCode = this.currentLanguageCode[0];
      this.currentThemeBean = ThemeBean(
        themeName: languageCode == 'zh' ? '不见五指' : 'dark',
        colorBean: ColorBean.fromColor(MyThemeColor.darkColor),
        themeType: MyTheme.darkTheme,
      );
    }
  }

  //当为夜间模式时候，白色替换为灰色
  Color getWhiteInDark() {
    final themeType = currentThemeBean.themeType;
    return themeType == MyTheme.darkTheme ? Colors.grey : Colors.white;
  }

  Color getNavColor() {
    return footColor;
    final themeType = currentThemeBean.themeType;
    return themeType == MyTheme.darkTheme
        ? Colors.black26
        : Color.fromRGBO(
            currentThemeBean.colorBean.red - 20 <= 0
                ? currentThemeBean.colorBean.red
                : currentThemeBean.colorBean.red - 20,
            currentThemeBean.colorBean.green - 20 <= 0
                ? currentThemeBean.colorBean.green
                : currentThemeBean.colorBean.green - 20,
            currentThemeBean.colorBean.blue - 20 <= 0
                ? currentThemeBean.colorBean.blue
                : currentThemeBean.colorBean.blue - 20,
            currentThemeBean.colorBean.opacity);
  }

  //当为夜间模式时候，白色背景替换为特定灰色
  Color getBgInDark() {
    final themeType = currentThemeBean.themeType;
    return themeType == MyTheme.darkTheme
        ? currentThemeBean.colorBean
        : Colors.white;
  }

  //当为夜间模式时候，主题色背景替换为灰色
  Color getPrimaryGreyInDark(BuildContext context) {
    final themeType = currentThemeBean.themeType;
    return themeType == MyTheme.darkTheme
        ? Colors.grey
        : Theme.of(context).primaryColor;
  }

  //当为夜间模式时候，主题色背景替换为灰色
  Color getNavInDark(BuildContext context) {
    final themeType = currentThemeBean.themeType;
    return themeType == MyTheme.darkTheme ? Colors.grey : Colors.white60;
  }

  //当为夜间模式时候，主题色背景替换为灰色
  Color getNavInActiveDark(BuildContext context) {
    final themeType = currentThemeBean.themeType;
    return themeType == MyTheme.darkTheme ? Colors.white : Colors.white;
  }

  /**
   * 编辑
   */
  editReport(ReportBean reportBean, context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return ProviderConfig.getInstance().getReportDetailPage(reportBean);
    }));
  }

  getBackground() {
    return BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: mainTheme.Colors.loginGradientStart,
          offset: Offset(1.0, 6.0),
          blurRadius: 20.0,
        ),
        BoxShadow(
          color: mainTheme.Colors.loginGradientEnd,
          offset: Offset(1.0, 6.0),
          blurRadius: 20.0,
        ),
      ],
      gradient: new LinearGradient(
          colors: [
            mainTheme.Colors.loginGradientStart,
            mainTheme.Colors.loginGradientEnd,
          ],
          begin: const FractionalOffset(0.2, 0.2),
          end: const FractionalOffset(1.0, 1.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp),
    );
    return BoxDecoration(
      gradient: LinearGradient(colors: [
        Colors.white,
        backColor,
        backColor.withAlpha(999),
      ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      color: backColor,
    );
  }

  @override
  void dispose() {
    super.dispose();
    debugPrint("GlobalModel销毁了");
  }

  void refresh() {
    notifyListeners();
  }
}
