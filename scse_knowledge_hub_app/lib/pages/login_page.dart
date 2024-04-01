import 'dart:developer';
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scse_knowledge_hub_app/utils/auth_helper.dart';
import 'package:scse_knowledge_hub_app/pages/email_verfication_page.dart';
import 'package:scse_knowledge_hub_app/pages/home_page.dart';
import 'package:scse_knowledge_hub_app/providers/user_provider.dart';
import 'package:scse_knowledge_hub_app/utils/styles.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late UserProvider _userProvider;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _isRegister = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _userProvider = Provider.of(context);
    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);

              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: const [
                Color.fromRGBO(30, 90, 162, 1),
                Color.fromRGBO(60, 104, 158, 1),
                Color.fromRGBO(82, 115, 156, 1)
              ])),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 80,
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _isRegister
                            ? Text(
                                "Register",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold),
                              )
                            : Text(
                                "Login",
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
                      child: Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.all(30),
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 60,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Styles.primaryGreyColor,
                                            blurRadius: 35,
                                            offset: Offset(0, 10))
                                      ]),
                                  child: Column(
                                    children: <Widget>[
                                      if (true == _isRegister)
                                        Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      color: Colors.grey))),
                                          child: TextFormField(
                                            controller: _nameController,
                                            decoration: InputDecoration(
                                              hintText: "Username",
                                              hintStyle:
                                                  TextStyle(color: Colors.grey),
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    color: Colors.grey))),
                                        child: TextFormField(
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Please enter a NTU email";
                                            }
                                            if (false == _isNtuEmail(value)) {
                                              log(value.toString());
                                              return "Please enter a valid NTU email";
                                            }
                                            return null;
                                          },
                                          controller: _emailController,
                                          decoration: InputDecoration(
                                              hintText: "NTU Email",
                                              hintStyle:
                                                  TextStyle(color: Colors.grey),
                                              border: InputBorder.none),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    color: Colors.grey))),
                                        child: TextFormField(
                                          obscureText: _obscurePassword,
                                          controller: _passwordController,
                                          decoration: InputDecoration(
                                              hintText: "Password",
                                              hintStyle:
                                                  TextStyle(color: Colors.grey),
                                              border: InputBorder.none,
                                              suffixIcon: IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    _obscurePassword =
                                                        !_obscurePassword;
                                                  });
                                                },
                                                icon: Icon(_obscurePassword
                                                    ? Icons.visibility_off
                                                    : Icons.visibility),
                                              )),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _isRegister = !_isRegister;
                                    setState(() {});
                                  },
                                  child: _isRegister
                                      ? Text(
                                          "Already Registered?",
                                          style: TextStyle(color: Colors.grey),
                                        )
                                      : Text(
                                          "Don't have an account yet?",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                                SizedBox(
                                  height: 45,
                                  width: Styles.kScreenWidth(context) * 0.60,
                                  child: ElevatedButton(
                                      onPressed: () async {
                                        await _verficationButton(context);
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Styles.primaryBlueColor,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20))),
                                      child: _isRegister
                                          ? Text(
                                              "Register",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            )
                                          : Text(
                                              "Login",
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
                    ),
                  )
                ],
              ),
            ),
          ),
          if (_isLoading)
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
                ))
        ],
      ),
    );
  }

  Future<void> _verficationButton(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _isLoading = true;
      setState(() {});
      User? user;
      if (true == _isRegister) {
        user = await _signUp(
            userName: _nameController.text.trim(),
            userEmail: _emailController.text.trim(),
            userPassword: _passwordController.text.trim(),
            context: context);
        if (user != null) {
          log("user is registered");
          log(user.uid);
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => EmailVerificationPage(
                  userName: _nameController.text,
                  userEmail: _emailController.text)));
        }
      } else {
        user = await _login(
          userEmail: _emailController.text.trim(),
          userPassword: _passwordController.text.trim(),
        );
        if (user != null) {
          await _userProvider.setUser(userID: user.uid);

          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomePage()));
        }
      }
      _isLoading = false;
      setState(() {});
    }
  }

  bool _isNtuEmail(String email) {
    // Define a regular expression pattern for email validation
    // The pattern ensures the email ends with "ntu.edu.sg"
    RegExp regex =
        RegExp(r"^[a-zA-Z0-9._%+-]+@(e\.)?ntu\.edu\.sg$", caseSensitive: false);

    // Use the hasMatch method to check if the email matches the pattern
    return regex.hasMatch(email);
  }

  Future<User?> _signUp(
      {required String userName,
      required String userEmail,
      required String userPassword,
      required BuildContext context}) async {
    var res = await AuthHelper.signUp(email: userEmail, password: userPassword);
    if (res.runtimeType != String) {
      return res as User;
    } else {
      switch (res) {
        case 'weak-password':
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('The password provided is too weak.')));
          break;
        case 'email-already-in-use':
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('The account already exists for that email.')));
          break;
        default:
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Login unsuccessful. Please try again')));
      }
      return null;
    }
  }

  Future<User?> _login(
      {required String userEmail, required String userPassword}) async {
    var res = await AuthHelper.logIn(email: userEmail, password: userPassword);
    if (res.runtimeType != String) {
      return res as User;
    } else {
      switch (res) {
        case "user-not-found":
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
                  'This account does not exist. Please register a new account if you have not.')));
          break;
        case "wrong-password":
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('You have entered a wrong password')));
          break;
        default:
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Login unsuccessful. Please try again')));
      }
      return null;
    }
  }
}
