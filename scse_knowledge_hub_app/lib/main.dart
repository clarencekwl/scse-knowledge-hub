import 'dart:async';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scse_knowledge_hub_app/providers/notification_provider.dart';
import 'package:scse_knowledge_hub_app/providers/question_provider.dart';
import 'package:scse_knowledge_hub_app/providers/user_provider.dart';
import 'package:scse_knowledge_hub_app/utils/auth_helper.dart';
import 'package:scse_knowledge_hub_app/pages/home_page.dart';
import 'package:scse_knowledge_hub_app/pages/login_page.dart';
import 'package:scse_knowledge_hub_app/pages/unknown_page.dart';
import 'package:scse_knowledge_hub_app/utils/router.dart';
import 'package:scse_knowledge_hub_app/utils/styles.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);
  runApp(MyApp());
}

Future<void> _backgroundMessageHandler(RemoteMessage message) async {
  //! APP IN BACKGROUND
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    log("App in background message data: ${message.data}");
    await NotificationProvider().onReceiveBackgroundNotification(message);
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthHelper.getUserLoginState(),
      builder: (context, snapshot) {
        bool? isLoggedIn = snapshot.data;
        if (isLoggedIn == null) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }

        return MultiProvider(
          providers: [
            ChangeNotifierProvider<QuestionProvider>(
              create: (_) => QuestionProvider(),
            ),
            ChangeNotifierProvider<UserProvider>(
              create: (_) => UserProvider(),
            ),
          ],
          child: MaterialApp(
            title: 'SCSE Knowledge Hub',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primaryColor: Styles.primaryBlueColor,
              brightness: Brightness.light,
              fontFamily: 'Inter',
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              fontFamily: 'Inter',
            ),
            themeMode: ThemeMode.light,
            home: isLoggedIn ? AutoLoginScreen() : LoginPage(),
            routes: appRoutes as Map<String, Widget Function(BuildContext)>,
            onUnknownRoute: (RouteSettings settings) {
              return MaterialPageRoute(
                builder: (BuildContext context) => UnknownPage(),
              );
            },
          ),
        );
      },
    );
  }
}

class AutoLoginScreen extends StatefulWidget {
  @override
  _AutoLoginScreenState createState() => _AutoLoginScreenState();
}

class _AutoLoginScreenState extends State<AutoLoginScreen> {
  late UserProvider _userProvider;
  @override
  void initState() {
    super.initState();
    // Attempt auto-login
    _tryAutoLogin();
  }

  @override
  Widget build(BuildContext context) {
    _userProvider = Provider.of(context);
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                pinned: true,
                backgroundColor: Styles.primaryBlueColor,
                expandedHeight: Styles.kScreenHeight(context) * 0.16,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: [
                      Container(
                        color: Styles.primaryBlueColor,
                      ),
                      Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            width: Styles.kScreenWidth(context) * 0.4,
                            height: Styles.kScreenHeight(context) * 0.15,
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(50)),
                            ),
                          )),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.black.withOpacity(0.3),
            child: Center(
              child: SizedBox(
                  height: 50,
                  width: 50,
                  child: CircularProgressIndicator(
                      color: Styles.primaryBlueColor)),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _tryAutoLogin() async {
    String? userEmail = await AuthHelper.getUserEmail();
    String? userId = await AuthHelper.getUserId();

    if (userEmail != null && userId != null) {
      FirebaseAuth.instance.currentUser?.reload();
      if (FirebaseAuth.instance.currentUser?.emailVerified ?? false) {
        // Set user details to the provider
        await _userProvider.setUser(userID: userId);
        log("user is: ${_userProvider.user}");
        // Navigate to the home page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        log("user email not verified!");
        // Clear stored details as they are invalid or missing
        await AuthHelper.saveUserLoginState(false);
        await AuthHelper.clearUserDetails();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
    } else {
      log("user email/id is null");
      // Clear stored details as they are invalid or missing
      await AuthHelper.saveUserLoginState(false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
    return;
  }
}
