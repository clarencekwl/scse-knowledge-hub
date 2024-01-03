import 'dart:async';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  // AuthHelper.clearAllSharedPreferences();

  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Check if the user is logged in or not
      future: AuthHelper.getUserLoginState(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          bool isLoggedIn = snapshot.data as bool;
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
        } else {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
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
        body: Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.black.withOpacity(0.3),
            child: Center(
              child: SizedBox(
                  height: 50,
                  width: 50,
                  child: CircularProgressIndicator(
                      color: Styles.primaryBlueColor)),
            )));
  }

  Future<void> _tryAutoLogin() async {
    String? userEmail = await AuthHelper.getUserEmail();
    String? userId = await AuthHelper.getUserId();
    log("current user email: ${userEmail}");
    if (userEmail != null && userId != null) {
      log("current user email: ${userEmail}");
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
        // Clear stored details as they are invalid or missing
        await AuthHelper.saveUserLoginState(false);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
    } else {
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
