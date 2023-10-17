import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scse_knowledge_hub_app/firebase_constants.dart';
import 'package:scse_knowledge_hub_app/pages/home_page.dart';
import 'package:scse_knowledge_hub_app/utils/styles.dart';
import 'package:scse_knowledge_hub_app/widget/loading.dart';

class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({Key? key}) : super(key: key);

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  bool isEmailVerified = false;
  Timer? timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAuth.instance.currentUser?.sendEmailVerification();
    timer =
        Timer.periodic(const Duration(seconds: 3), (_) => checkEmailVerified());
  }

  checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser?.reload();

    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (isEmailVerified) {
      // TODO: implement your code after email verification
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Email Successfully Verified")));
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const HomePage()));
      timer?.cancel();
    }
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: const [
            Color.fromRGBO(30, 90, 162, 1),
            Color.fromRGBO(60, 104, 158, 1),
            Color.fromRGBO(82, 115, 156, 1)
          ])),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 80,
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const <Widget>[
                    Text(
                      "Register",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Welcome to SCSE Knowledge Hub",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40))),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Text(
                          'Check your Email',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Center(
                          child: Text(
                            'We have sent you an email on  ${auth.currentUser?.email}',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 25),
                        Center(
                            child: Center(
                                child: Loading(
                          height: 50,
                          width: 50,
                          size: 50,
                          backgroundColor: Colors.transparent,
                          iconColor: Styles.primaryBlueColor,
                        ))),
                        const SizedBox(height: 30),
                        Center(
                          child: Text(
                            'Verifying email....',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 60),
                        SizedBox(
                          height: 45,
                          width: Styles.kScreenWidth(context) * 0.40,
                          child: ElevatedButton(
                              onPressed: () async {
                                try {
                                  FirebaseAuth.instance.currentUser
                                      ?.sendEmailVerification();
                                } catch (e) {
                                  debugPrint('$e');
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Styles.primaryBlueColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20))),
                              child: Text(
                                "Resend",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}