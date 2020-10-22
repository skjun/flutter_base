import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:medical/utils/global_uitl.dart';

import 'SliderView.dart';

class LandingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LandingPageState();
}

getWidgets(index) {
  List<Widget> widgets = [
    Container(
      child: Center(
        child: Container(
            height: 300,
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.enhanced_encryption,
                  size: 200,
                  color: Colors.white,
                ),
                Text(
                  "记录体检报告",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            )),
      ),
    ),
    Container(
      child: Center(
        child: Container(
            height: 300,
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.trending_down,
                  size: 200,
                  color: Colors.white,
                ),
                Text(
                  "分析指标趋势",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            )),
      ),
    )
  ];

  return widgets[index];
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: GlobalUtil.getInstance().globalModel.getBackground(),
      child: Stack(
        children: <Widget>[
          Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: Swiper(
                loop: false,
                itemBuilder: (BuildContext context, int index) {
                  return getWidgets(index);
                },
                itemCount: 2,
                pagination: new SwiperPagination(
                    builder: SwiperPagination.dots,
                    margin: EdgeInsets.only(bottom: 50)),
                // pagination: new SwiperPagination(),
                // control: new SwiperControl(),
              ),

              //  Container(
              //   height: 300,
              //   child: Column(
              //     children: <Widget>[
              //       Icon(
              //         Icons.enhanced_encryption,
              //         size: 200,
              //         color: Colors.grey,
              //       ),
              //       Text(
              //         "记录体检报告",
              //         style:
              //             TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              //       ),
              //     ],
              //   ),
              // ),
            ),
          ),
          Positioned(
              bottom: 20,
              right: 20,
              child: Container(
                  child: OutlineButton(
                borderSide: BorderSide(color: Colors.white),
                onPressed: () {
                  GlobalUtil.getInstance().globalModel.firstVisedEnd(context);
                },
                child: Text(
                  "立即体验",
                  style: TextStyle(color: Colors.white),
                ),
              )))
        ],
      ),
    );
  }

  Widget onBordingBody() => Container(
        child: SliderLayoutView(),
      );
}
