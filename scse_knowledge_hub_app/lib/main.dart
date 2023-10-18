import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:scse_knowledge_hub_app/firebase_constants.dart';
import 'package:scse_knowledge_hub_app/pages/email_verfication_page.dart';
import 'package:scse_knowledge_hub_app/pages/login_page.dart';
import 'package:scse_knowledge_hub_app/pages/unknown_page.dart';
import 'package:scse_knowledge_hub_app/providers/question_provider.dart';
import 'package:scse_knowledge_hub_app/providers/user_provider.dart';
import 'package:scse_knowledge_hub_app/utils/router.dart';
import 'package:scse_knowledge_hub_app/utils/styles.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await firebaseInitialization;
  // await GlobalData().loadSharedPreferences();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Key key = UniqueKey();
  // GlobalData gd = GlobalData();

  void restartApp() {
    key = UniqueKey();
    // setState(() {});
  }

  // @override
  // void onResumed() {
  //   super.onResumed();
  // }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    try {
      return KeyedSubtree(
        key: key,
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider<QuestionProvider>(
                create: (_) => QuestionProvider()),
            ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider())
          ],
          child: MaterialApp(
            title: 'SCSE Knowledge Hub',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              // appBarTheme: AppBarTheme(
              //     iconTheme: IconThemeData(color: Colors.white),
              //     color: Styles.primaryBlueColor,
              //     systemOverlayStyle: SystemUiOverlayStyle(
              //         statusBarColor: Styles.primaryBlueColor,
              //         statusBarBrightness: Brightness.light,
              //         statusBarIconBrightness: Brightness.light)),
              // Define the default brightness and colors
              // brightness: Brightness.dark,
              primaryColor: Styles.primaryBlueColor,
              // accentColor: Colors.grey,
              brightness: Brightness.light,
              // primaryIconTheme: Theme.of(context).primaryIconTheme.copyWith(
              //       color: Styles.pixiumRedColor,
              //     ),
              // primaryTextTheme: Theme.of(context).primaryTextTheme.apply(
              //       bodyColor: Styles.pixiumRedColor,
              //     ),
              // for drawer color
              //canvasColor: Colors.white,
              // Define the default font family.
              fontFamily: 'Inter',
              // Define the default TextTheme. Use this to specify the default
              // text styling for headlines, titles, bodies of text, and more.
              //textTheme: Styles.appTextTheme,
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              // primaryColorDark: Styles.pixiumRedColor,
              // indicatorColor: Colors.white,
              fontFamily: 'Inter',
              // canvasColor: Colors.grey[800],
              // primaryIconTheme: Theme.of(context).primaryIconTheme.copyWith(
              //       color: Styles.pixiumRedColor,
              //     ),
              // primaryTextTheme: Theme.of(context).primaryTextTheme.apply(
              //       bodyColor: Styles.pixiumRedColor,
              //     ),
              // primaryTextTheme: TextTheme(
              //   headline6: TextStyle(color: Colors.red),
              // ),
              // appBarTheme: AppBarTheme(
              //   brightness: Brightness.dark,
              //   titleTextStyle: TextStyle(
              //     color: Styles.pixiumRedColor,
              //   ),
              // ),
              // cardColor: Colors.grey[600],
              // cardTheme: CardTheme(),
            ),
            themeMode: ThemeMode.light,
            // initialRoute: SplashScreenPage.routeName,
            home: LoginPage(),
            routes: appRoutes as Map<String, Widget Function(BuildContext)>,
            onUnknownRoute: (RouteSettings settings) {
              return MaterialPageRoute(
                builder: (BuildContext context) => UnknownPage(),
              );
            },
          ),
        ),
      );
    } on SocketException {
      return Container();
    } finally {}
  }
}
