import 'package:flutter/material.dart';
import 'package:medical/bean/patients.dart';
import 'package:medical/bean/report_bean.dart';
import 'package:medical/model/global_model.dart';
import 'package:medical/model/login_model.dart';
import 'package:medical/model/main_page_model.dart';
import 'package:medical/model/news_model.dart';
import 'package:medical/model/patient_model.dart';
import 'package:medical/model/report_model.dart';
import 'package:medical/model/report_set_model.dart';
import 'package:medical/model/theme_page_model.dart';
import 'package:medical/model/trend_model.dart';
import 'package:medical/pages/home/patient.dart';
import 'package:medical/pages/home/report_deal.dart';
import 'package:medical/pages/home/report_show_page.dart';
import 'package:medical/pages/login/login_page.dart';
import 'package:medical/pages/main/main_page.dart';
import 'package:medical/pages/news/newslist.dart';
import 'package:medical/pages/setting/theme_page.dart';
import 'package:medical/pages/trend/index.dart';
import 'package:medical/pages/user/setting_report.dart';
import 'package:medical/pages/user/setting_report_detail.dart';
import 'package:provider/provider.dart';

class ProviderConfig {
  static ProviderConfig _instance;

  static ProviderConfig getInstance() {
    if (_instance == null) {
      _instance = ProviderConfig._internal();
    }
    return _instance;
  }

  ProviderConfig._internal();

  ///全局provider
  ChangeNotifierProvider<GlobalModel> getGlobal(Widget child) {
    return ChangeNotifierProvider<GlobalModel>(
      create: (context) => GlobalModel(),
      child: child,
    );
  }

  ///主页provider
  ChangeNotifierProvider<LoginModel> getMainLogin() {
    return ChangeNotifierProvider<LoginModel>(
      create: (context) => LoginModel(),
      child: LoginPage(),
    );
  }

  ///主页provider
  ChangeNotifierProvider<MainPageModel> getMainPage() {
    return ChangeNotifierProvider<MainPageModel>(
      create: (context) => MainPageModel(),
      child: MainPage(),
    );
  }

  ///主题设置页provider
  ChangeNotifierProvider<ThemePageModel> getThemePage() {
    return ChangeNotifierProvider<ThemePageModel>(
      create: (context) => ThemePageModel(),
      child: ThemePage(),
    );
  }

  ///主题设置页provider
  ChangeNotifierProvider<PatientPageModel> getPatientPage(
      Patients olodPatient) {
    return ChangeNotifierProvider<PatientPageModel>(
      create: (context) => PatientPageModel(olodPatient),
      child: PatientPage(),
    );
  }

  ///主题设置页provider
  ChangeNotifierProvider<ReportModel> getReportDetailPage(
      ReportBean reportBean) {
    return ChangeNotifierProvider<ReportModel>(
      create: (context) => ReportModel(reportBean),
      child: ReportPage(),
    );
  }

  ///主题设置页provider
  ChangeNotifierProvider<ReportModel> getReportForShow(ReportBean reportBean) {
    return ChangeNotifierProvider<ReportModel>(
      create: (context) => ReportModel(reportBean),
      child: ReportShowPage(),
    );
  }

  //统计分析页面
  ChangeNotifierProvider<TrendModel> getTrendPageView() {
    return ChangeNotifierProvider<TrendModel>(
      create: (context) => TrendModel(),
      child: TrendView(),
    );
  }

  //统计分析页面
  ChangeNotifierProvider<NewsModel> getNewsPageView() {
    return ChangeNotifierProvider<NewsModel>(
      create: (context) => NewsModel(),
      child: NewsPage(),
    );
  }

  //统计分析页面
  ChangeNotifierProvider<ReportSetModel> getReportSetPage() {
    return ChangeNotifierProvider<ReportSetModel>(
      create: (context) => ReportSetModel(null),
      child: SetReportPage(),
    );
  }

  //统计分析页面
  ChangeNotifierProvider<ReportSetModel> getReportSetDetailPage(
      int report_type_id) {
    return ChangeNotifierProvider<ReportSetModel>(
      create: (context) => ReportSetModel(report_type_id),
      child: SetReportDetailPage(),
    );
  }
}
