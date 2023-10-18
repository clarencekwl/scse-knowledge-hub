import 'package:flutter/material.dart';
import 'package:scse_knowledge_hub_app/api/user_api.dart' as UserAPI;

class UserProvider extends ChangeNotifier {
  Future<void> getUser(String userID) async {
    startLoading();
    await UserAPI.getUser(userID);
    stopLoading();
  }

  Future<void> createUser(
      {required String userID, required String userEmail}) async {
    startLoading();
    await UserAPI.createUser(userID: userID, userEmail: userEmail);
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
