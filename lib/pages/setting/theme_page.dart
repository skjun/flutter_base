import 'package:flutter/material.dart';
import 'package:phonebase/i10n/localization_intl.dart';
import 'package:phonebase/model/global_model.dart';
import 'package:phonebase/model/theme_page_model.dart';
import 'package:phonebase/pages/widgets/custom_animated_switcher.dart';
import 'package:provider/provider.dart';

class ThemePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<ThemePageModel>(context)..setContext(context);
    final globalModel = Provider.of<GlobalModel>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          IntlLocalizations.of(context).changeTheme,
        ),
        actions: <Widget>[
          model.themes.length > 7
              ? CustomAnimatedSwitcher(
                  firstChild: IconButton(
                    icon: Icon(
                      Icons.border_color,
                      size: 18,
                      color: globalModel.getWhiteInDark(),
                    ),
                    onPressed: null,
                  ),
                  secondChild: IconButton(
                    icon: Icon(
                      Icons.check,
                      color: globalModel.getWhiteInDark(),
                    ),
                    onPressed: null,
                  ),
                  hasChanged: model.isDeleting,
                  onTap: () {
                    model.isDeleting = !model.isDeleting;
                    model.refresh();
                  },
                )
              : SizedBox(),
        ],
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child: ListView(
          children: <Widget>[
            model.getRandomColorBloc(size, globalModel),
            ...List.generate(model.themes.length, (index) {
              final themeBean = model.themes[index];
              return Stack(
                children: <Widget>[
                  AbsorbPointer(
                    absorbing: model.isDeleting,
                    child: model.getThemeBloc(
                      themeBean,
                      size,
                      globalModel,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: model.isDeleting && index > 6
                        ? IconButton(
                            icon: Icon(
                              Icons.cancel,
                              color: Colors.redAccent,
                            ),
                            onPressed: () => model.removeIcon(index),
                          )
                        : Container(),
                  )
                ],
              );
            }),
            Container(
              height: (size.width - 140) / 4,
              margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  gradient: globalModel.enableAutoDarkMode
                      ? LinearGradient(colors: [
                          Colors.grey,
                          Colors.white,
                        ], begin: Alignment.topLeft, end: Alignment.bottomRight)
                      : LinearGradient(
                          colors: [
                              Colors.white,
                              Colors.grey,
                            ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight)),
              child: SwitchListTile(
                title: Text(
                  '    ' +
                      "autoDarkMode" +
                      ' ${model.getTimeRangeText(globalModel.autoDarkModeTimeRange, globalModel.enableAutoDarkMode)}',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12),
                ),
                secondary: Icon(
                  Icons.highlight,
                  color: globalModel.enableAutoDarkMode
                      ? Colors.white
                      : Theme.of(context).iconTheme.color,
                ),
                value: globalModel.enableAutoDarkMode,
                activeColor: Colors.black,
                onChanged: (value) =>
                    model.onAutoThemeChanged(globalModel, value),
              ),
            ),
            model.isDeleting
                ? Container()
                : InkWell(
                    onTap: model.createCustomTheme,
                    child: Container(
                      height: (size.width - 140) / 4,
                      margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 40,
                      ),
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          gradient: LinearGradient(
                              colors: [
                                Colors.redAccent,
                                Colors.greenAccent,
                                Colors.blueAccent,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight)),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
