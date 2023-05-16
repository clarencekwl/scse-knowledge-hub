import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scse_knowledge_hub_app/pages/home_page.dart';
import 'package:scse_knowledge_hub_app/utils/styles.dart';

class SplashScreenPage extends StatefulWidget {
  static const String routeName = '/splash';

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
      SystemUiOverlay.bottom,
    ]);
    Timer(Duration(seconds: 3), () {
      // use shared preferences to check if its user's first time opening this app
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);

      // bool? displayGetStarted = GlobalData().get("display_get_started");
      // log("displayGetStarted: ${displayGetStarted}");
      // if (null != displayGetStarted) {
      //   Navigator.of(context).pushReplacement(
      //       MaterialPageRoute(builder: (context) => CaseOverviewPage()));
      // } else {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Stack(children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 1,
                  child: Image.asset(
                    'assets/images/scse-knowledge-hub-icon.png',
                    fit: BoxFit.fill,
                  ),
                ),
              ],
            ),
          ),
        ),
        // Positioned(
        //   top: 0,
        //   left: 0,
        //   child: Image.asset(
        //     'assets/images/top_left_splash_image.png',
        //     width: Styles.kScreenWidth(context) * 0.6,
        //   ),
        // ),
        // Positioned(
        //   bottom: 0,
        //   right: 0,
        //   child: Image.asset(
        //     'assets/images/bottom_right_splash_image.png',
        //     width: Styles.kScreenWidth(context) * 0.6,
        //   ),
        // )
      ]),
    );
  }
}
