import 'dart:async';

import 'package:flutter/material.dart';
import 'package:medical/model/global_model.dart';
import 'package:medical/pages/borading/sliderDots.dart';
import 'package:medical/pages/borading/sliderItems.dart';
import 'package:medical/pages/widgets/TextStyles.dart';
import 'package:medical/utils/consts.dart';
import 'package:medical/utils/global_uitl.dart';
import 'package:medical/utils/provider_config.dart';
import 'package:provider/provider.dart';

import 'Slider.dart';

class SliderLayoutView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SliderLayoutViewState();
}

class _SliderLayoutViewState extends State<SliderLayoutView> {
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    onPressed() {
      GlobalUtil.getInstance().globalModel.firstVisedEnd(context);
      // final globalModel = Provider.of<GlobalModel>(context);
      // globalModel.firstVisedEnd(context);
    }

    return Container(
      child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: <Widget>[
              PageView.builder(
                scrollDirection: Axis.horizontal,
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: sliderArrayList.length,
                itemBuilder: (ctx, i) => SlideItem(i),
              ),
              Stack(
                alignment: AlignmentDirectional.topStart,
                children: <Widget>[
                  Align(
                    alignment: Alignment.bottomRight,
                    child: InkWell(
                      onTap: () {
                        if (_currentPage == 2) {
                          // Navigator.push(context,
                          //     MaterialPageRoute(builder: (_) {
                          //   return ProviderConfig.getInstance().getMainPage();
                          // }));
                          onPressed();
                        } else {
                          _currentPage = _currentPage + 1;
                          _pageController.jumpToPage(_currentPage);
                        }

                        setState(() {});
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: 15.0, bottom: 15.0),
                        child: BoldText(NEXT, 14, kblack),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: InkWell(
                        onTap: () {
                          onPressed();
                        },
                        child: Padding(
                          padding: EdgeInsets.only(left: 15.0, bottom: 15.0),
                          child: BoldText(SKIP, 14, kblack),
                        )),
                  ),
                  Container(
                    alignment: AlignmentDirectional.bottomCenter,
                    margin: EdgeInsets.only(bottom: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        for (int i = 0; i < sliderArrayList.length; i++)
                          if (i == _currentPage)
                            SlideDots(true)
                          else
                            SlideDots(false)
                      ],
                    ),
                  ),
                ],
              )
            ],
          )),
    );
  }
}
