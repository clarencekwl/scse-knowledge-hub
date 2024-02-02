import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scse_knowledge_hub_app/models/User.dart';

class UserResponse {
  User user;

  UserResponse({required this.user});
  factory UserResponse.fromJson(DocumentSnapshot<Map<String, dynamic>> json) {
    // List<dynamic>? list = json.map((e) => e.data()).toList();
    return UserResponse(user: User.fromJson(json.data()!, json.id));
  }
}
