import 'package:flutter/material.dart';
import 'package:phonebase/model/global_model.dart';
import 'package:phonebase/model/test_page_model.dart';
import 'package:provider/provider.dart';

class MulPage extends StatelessWidget {
  Widget build(BuildContext context) {
    final model = Provider.of<TestPageModel>(context);
    final globalModel = Provider.of<GlobalModel>(context);
    model.setContext(context, globalModel: globalModel);
    return Container(
      child: Scaffold(
        key: model.scaffoldKey,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text("多功能页面"),
        ),
//          drawer: Drawer(
//            child: NavPage(),
//          ),
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: GestureDetector(
          onLongPress: () {
            showModalBottomSheet(
                context: context,
                builder: (ctx) {
                  //  return buildSettingListView(context, globalModel);
                });
          },
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Text("首页1"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
