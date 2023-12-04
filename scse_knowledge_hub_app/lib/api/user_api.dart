import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scse_knowledge_hub_app/reponse/user_response.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;

Future<UserReponse> getUser({required String userID}) async {
  DocumentSnapshot<Map<String, dynamic>> snapshot =
      await db.collection("users").doc(userID).get();

  return UserReponse.fromJson(snapshot);
}

Future<void> createUser(
    {required String userID,
    required String userName,
    required String userEmail}) async {
  Map<String, dynamic> data = {
    "name": userName,
    "email": userEmail,
  };

  db.collection("users").doc(userID).set(data);
}
