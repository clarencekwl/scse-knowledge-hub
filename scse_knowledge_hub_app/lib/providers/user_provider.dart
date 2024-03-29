import 'package:flutter/material.dart';
import 'package:scse_knowledge_hub_app/api/user_api.dart' as UserAPI;
import 'package:scse_knowledge_hub_app/models/User.dart';
import 'package:scse_knowledge_hub_app/reponse/user_response.dart';

class UserProvider extends ChangeNotifier {
  late User _user;
  User get user => _user;
  set user(User user) {
    _user = user;
    notifyListeners();
  }

  Future<void> setUser({required String userID}) async {
    startLoading();
    UserResponse user = await UserAPI.getUser(userID: userID);
    _user = user.user;
    stopLoading();
  }

  Future<User> getUser({required String userID}) async {
    UserResponse user = await UserAPI.getUser(userID: userID);
    return user.user;
  }

  void incrementNumberOfQuestions() {
    _user.noOfQuestions = _user.noOfQuestions + 1;
    stopLoading();
  }

  void decrementNumberOfQuestions() {
    _user.noOfQuestions = _user.noOfQuestions - 1;
    stopLoading();
  }

  void incrementNumberOfQuestionReplies() {
    _user.noOfQuestionsReplied = _user.noOfQuestionsReplied + 1;
    stopLoading();
  }

  void decrementNumberOfQuestionReplies() {
    _user.noOfQuestionsReplied = _user.noOfQuestionsReplied - 1;
    stopLoading();
  }

  Future<void> createUser({
    required String userID,
    required String userName,
    required String userEmail,
  }) async {
    startLoading();
    await UserAPI.createUser(
        userID: userID, userName: userName, userEmail: userEmail);
    UserResponse user = await UserAPI.getUser(userID: userID);
    _user = user.user;
    stopLoading();
  }

  Future<void> changeUsername(
      {required String userId, required String newUsername}) async {
    startLoading();
    await UserAPI.changeUsername(userId: userId, newUsername: newUsername);
    UserResponse user = await UserAPI.getUser(userID: userId);
    _user = user.user;

    stopLoading();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  startLoading() {
    _isLoading = true;
    notifyListeners();
  }

  stopLoading() {
    _isLoading = false;
    notifyListeners();
  }
}
