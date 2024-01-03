import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthHelper {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<User?> logIn(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save user authentication state and details
      await saveUserLoginState(true);
      await saveUserDetails(userCredential.user);

      return userCredential.user;
    } catch (e) {
      log("Error loggin in: $e");
      return null;
    }
  }

  static Future<User?> signUp(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      await saveUserLoginState(true);
      await saveUserDetails(userCredential.user);

      return userCredential.user;
    } catch (e) {
      log("Error signing up: $e");
      return null;
    }
  }

  static Future<void> saveUserLoginState(bool isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool loginState = await prefs.setBool('isLoggedIn', isLoggedIn);
    log("set isLoggedIn to be : $loginState");
  }

  static Future<void> saveUserDetails(User? user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userId', user?.uid ?? '');
    prefs.setString('email', user?.email ?? '');
    // Add more user details as needed
  }

  static Future<bool> getUserLoginState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    log("isLoggedIn : ${prefs.getBool("isLoggedIn")}");
    return prefs.getBool('isLoggedIn') ?? false;
  }

  static Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  static Future<String?> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('email');
  }

  static Future<void> clearUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('userId');
    prefs.remove('email');
  }

  static Future<void> logOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      await clearUserDetails();
      await saveUserLoginState(false);
    } catch (e) {
      log('Error during sign out: $e');
      // Handle sign-out error, if any
    }
  }
}
