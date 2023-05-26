import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scse_knowledge_hub_app/models/User.dart';

class UserReponse {
  User user;

  UserReponse({required this.user});
  factory UserReponse.fromJson(DocumentSnapshot<Map<String, dynamic>> json) {
    // List<dynamic>? list = json.map((e) => e.data()).toList();
    return UserReponse(user: User.fromJson(json.data()!, json.id));
  }
}
