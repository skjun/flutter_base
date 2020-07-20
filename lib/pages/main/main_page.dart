import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phonebase/model/global_model.dart';
import 'package:phonebase/model/main_page_model.dart';
import 'package:phonebase/pages/widgets/menu_icon.dart';
import 'package:phonebase/pages/widgets/nav_page.dart';
import 'package:phonebase/utils/toast_util.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  final List _bottomBarItems = [
    {'title': '首页', 'name': 'home', 'icon': Icons.home, 'widget': Container()},
    {
      'title': '挂牌',
      'name': 'trade',
      'icon': Icons.memory,
      'widget': Container()
    },
    {
      'title': '个人',
      'name': 'personal',
      'icon': Icons.person,
      'widget': Container()
    }
  ];

  int _currentIndex = 0;

  final _pageController = PageController();

  String title = "";
  @override
  void initState() {
    super.initState();
    title = _bottomBarItems[0]['title'];
  }

  void _onTapBottomBar(int index) {
    if (index == _currentIndex) return;
    _pageController.jumpToPage(index);
  }

  void onPageChanged(int index) {
    setState(() {
      title = _bottomBarItems[index]['title'];
      _currentIndex = index;
    });
  }

  DateTime lastPopTime;
  Widget build(BuildContext context) {
    final model = Provider.of<MainPageModel>(context);
    final globalModel = Provider.of<GlobalModel>(context);
    final size = MediaQuery.of(context).size;
    model.setContext(context, globalModel: globalModel);

    return SafeArea(
        child: WillPopScope(
      child: Container(
        decoration: model.getBackground(globalModel),
        child: Scaffold(
          key: model.scaffoldKey,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(title),
            leading: FlatButton(
              child: MenuIcon(globalModel.getWhiteInDark()),
              onPressed: () {
                model.scaffoldKey.currentState.openDrawer();
              },
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.search,
                  size: 28,
                  color: globalModel.getWhiteInDark(),
                ),
                onPressed: () => {ToastUtil.showCommon('再按一次退出应用')},
              )
            ],
          ),
          drawer: Drawer(
            child: NavPage(),
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: globalModel.getNavColor(),
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white54,
            items: _bottomBarItems.map((el) {
              return BottomNavigationBarItem(
                  icon: Icon(el['icon']), title: Text(el['title']));
            }).toList(),
            currentIndex: _currentIndex,
            type: BottomNavigationBarType.fixed, // 大于3个底部导航需要设置fixed定位
            onTap: _onTapBottomBar,
            selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
            //   bottomNavigationBar:
          ),
          body: PageView(
            controller: _pageController,
            onPageChanged: onPageChanged,
            children: _bottomBarItems
                .map((el) {
                  return el['widget'];
                })
                .cast<Widget>()
                .toList(),
            physics: NeverScrollableScrollPhysics(), // 禁止滑动
          ),
        ),
      ),
      onWillPop: () {
        // 点击返回键的操作
        if (lastPopTime == null ||
            DateTime.now().difference(lastPopTime) > Duration(seconds: 2)) {
          lastPopTime = DateTime.now();
          ToastUtil.showCommon('再按一次退出应用');
        } else {
          lastPopTime = DateTime.now();
          // 退出app
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        }
      },
    ));
  }
}
