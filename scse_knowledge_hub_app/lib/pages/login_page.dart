// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:scse_knowledge_hub_app/pages/home_page.dart';
// import 'package:scse_knowledge_hub_app/utils/styles.dart';
// import 'package:scse_knowledge_hub_app/widget/default_button.dart';

// class LoginPage extends StatefulWidget {
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   bool _rememberMe = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       backgroundColor: Styles.primaryBackgroundColor,
//       body: GestureDetector(
//         onTap: () => FocusScope.of(context).unfocus(),
//         child: Column(
//           children: [
//             Expanded(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 mainAxisSize: MainAxisSize.max,
//                 children: <Widget>[
//                   SizedBox(
//                     height: Styles.kScreenHeight(context) * 0.1,
//                   ),
//                   Image.asset(
//                     'assets/images/scse-knowledge-hub-icon.png',
//                     height: Styles.kScreenHeight(context) * 0.3,
//                     width: Styles.kScreenHeight(context) * 0.3,
//                     fit: BoxFit.fill,
//                   ),
//                   Expanded(
//                     child: Container(
//                       decoration: BoxDecoration(
//                           border: Border.all(color: Styles.primaryBlueColor),
//                           borderRadius: BorderRadius.circular(10)),
//                       child: Column(
//                         children: [
//                           // Text(
//                           //   'Sign In',
//                           //   style: TextStyle(
//                           //     color: Colors.white,
//                           //     fontFamily: 'OpenSans',
//                           //     fontSize: 30.0,
//                           //     fontWeight: FontWeight.bold,
//                           //   ),
//                           // ),
//                           _buildEmailTF(),
//                           SizedBox(
//                             height: 30.0,
//                           ),
//                           _buildPasswordTF(),
//                           // _buildForgotPasswordBtn(),
//                           // _buildRememberMeCheckbox(),
//                           _buildLoginBtn(),
//                         ],
//                       ),
//                     ),
//                   ),
//                   // _buildSignInWithText(),
//                   // _buildSocialBtnRow(),
//                   // _buildSignupBtn(),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildEmailTF() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         Text(
//           'Email',
//           style: Styles.loginLabelStyle,
//         ),
//         SizedBox(height: 10.0),
//         Container(
//           alignment: Alignment.centerLeft,
//           decoration: Styles.loginBoxDecorationStyle,
//           height: 60.0,
//           child: TextField(
//             keyboardType: TextInputType.emailAddress,
//             style: TextStyle(
//               color: Colors.white,
//               fontFamily: 'OpenSans',
//             ),
//             decoration: InputDecoration(
//               border: InputBorder.none,
//               contentPadding: EdgeInsets.only(top: 14.0),
//               prefixIcon: Icon(
//                 Icons.email,
//                 color: Colors.white,
//               ),
//               hintText: 'Enter your Email',
//               hintStyle: Styles.loginHintTextStyle,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildPasswordTF() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         Text(
//           'Password',
//           style: Styles.loginLabelStyle,
//         ),
//         SizedBox(height: 10.0),
//         Container(
//           alignment: Alignment.centerLeft,
//           decoration: Styles.loginBoxDecorationStyle,
//           height: 60.0,
//           child: TextField(
//             obscureText: true,
//             style: TextStyle(
//               color: Colors.white,
//               fontFamily: 'OpenSans',
//             ),
//             decoration: InputDecoration(
//               border: InputBorder.none,
//               contentPadding: EdgeInsets.only(top: 14.0),
//               prefixIcon: Icon(
//                 Icons.lock,
//                 color: Colors.white,
//               ),
//               hintText: 'Enter your Password',
//               hintStyle: Styles.loginHintTextStyle,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

// Widget _buildLoginBtn() {
//   return Container(
//     padding: EdgeInsets.symmetric(vertical: 25.0),
//     width: double.infinity,
//     child: DefaultButton(
//       onPressed: () => Navigator.of(context).push(MaterialPageRoute(
//         builder: (context) => LoginPage(),
//       )),
//       buttonColor: Colors.white,
//       textColour: Styles.primaryBlueColor,
//       title: "LOGIN",
//     ),
//   );
// }

//   // Widget _buildForgotPasswordBtn() {
//   //   return Container(
//   //     alignment: Alignment.centerRight,
//   //     child: FlatButton(
//   //       onPressed: () => print('Forgot Password Button Pressed'),
//   //       padding: EdgeInsets.only(right: 0.0),
//   //       child: Text(
//   //         'Forgot Password?',
//   //         style: Styles.kLabelStyle,
//   //       ),
//   //     ),
//   //   );
//   // }

//   // Widget _buildRememberMeCheckbox() {
//   //   return Container(
//   //     height: 20.0,
//   //     child: Row(
//   //       children: <Widget>[
//   //         Theme(
//   //           data: ThemeData(unselectedWidgetColor: Colors.white),
//   //           child: Checkbox(
//   //             value: _rememberMe,
//   //             checkColor: Colors.green,
//   //             activeColor: Colors.white,
//   //             onChanged: (value) {
//   //               setState(() {
//   //                 _rememberMe = value;
//   //               });
//   //             },
//   //           ),
//   //         ),
//   //         Text(
//   //           'Remember me',
//   //           style: Styles.kLabelStyle,
//   //         ),
//   //       ],
//   //     ),
//   //   );
//   // }

//   // Widget _buildSignInWithText() {
//   //   return Column(
//   //     children: <Widget>[
//   //       Text(
//   //         '- OR -',
//   //         style: TextStyle(
//   //           color: Colors.white,
//   //           fontWeight: FontWeight.w400,
//   //         ),
//   //       ),
//   //       SizedBox(height: 20.0),
//   //       Text(
//   //         'Sign in with',
//   //         style: kLabelStyle,
//   //       ),
//   //     ],
//   //   );
//   // }

//   // Widget _buildSocialBtn(Function onTap, AssetImage logo) {
//   //   return GestureDetector(
//   //     onTap: onTap,
//   //     child: Container(
//   //       height: 60.0,
//   //       width: 60.0,
//   //       decoration: BoxDecoration(
//   //         shape: BoxShape.circle,
//   //         color: Colors.white,
//   //         boxShadow: [
//   //           BoxShadow(
//   //             color: Colors.black26,
//   //             offset: Offset(0, 2),
//   //             blurRadius: 6.0,
//   //           ),
//   //         ],
//   //         image: DecorationImage(
//   //           image: logo,
//   //         ),
//   //       ),
//   //     ),
//   //   );
//   // }

//   // Widget _buildSocialBtnRow() {
//   //   return Padding(
//   //     padding: EdgeInsets.symmetric(vertical: 30.0),
//   //     child: Row(
//   //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//   //       children: <Widget>[
//   //         _buildSocialBtn(
//   //           () => print('Login with Facebook'),
//   //           AssetImage(
//   //             'assets/logos/facebook.jpg',
//   //           ),
//   //         ),
//   //         _buildSocialBtn(
//   //           () => print('Login with Google'),
//   //           AssetImage(
//   //             'assets/logos/google.jpg',
//   //           ),
//   //         ),
//   //       ],
//   //     ),
//   //   );
//   // }

//   // Widget _buildSignupBtn() {
//   //   return GestureDetector(
//   //     onTap: () => print('Sign Up Button Pressed'),
//   //     child: RichText(
//   //       text: TextSpan(
//   //         children: [
//   //           TextSpan(
//   //             text: 'Don\'t have an Account? ',
//   //             style: TextStyle(
//   //               color: Colors.white,
//   //               fontSize: 18.0,
//   //               fontWeight: FontWeight.w400,
//   //             ),
//   //           ),
//   //           TextSpan(
//   //             text: 'Sign Up',
//   //             style: TextStyle(
//   //               color: Colors.white,
//   //               fontSize: 18.0,
//   //               fontWeight: FontWeight.bold,
//   //             ),
//   //           ),
//   //         ],
//   //       ),
//   //     ),
//   //   );
//   // }
// }

import 'package:flutter/material.dart';
import 'package:scse_knowledge_hub_app/pages/home_page.dart';
import 'package:scse_knowledge_hub_app/utils/styles.dart';
import 'package:scse_knowledge_hub_app/widget/default_button.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          children: <Widget>[
            SizedBox(
              height: 80,
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Register",
                    style: TextStyle(color: Colors.white, fontSize: 40),
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
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom:
                                            BorderSide(color: Colors.grey))),
                                child: TextField(
                                  decoration: InputDecoration(
                                      hintText: "NTU Email",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom:
                                            BorderSide(color: Colors.grey))),
                                child: TextField(
                                  decoration: InputDecoration(
                                      hintText: "Password",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Text(
                          "Forgot Password?",
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        SizedBox(
                          height: 45,
                          width: Styles.kScreenWidth(context) * 0.60,
                          child: ElevatedButton(
                              onPressed: () =>
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => HomePage(),
                                  )),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Styles.primaryBlueColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20))),
                              child: Text(
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
            )
          ],
        ),
      ),
    );
  }
}
