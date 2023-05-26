import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scse_knowledge_hub_app/reponse/user_response.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;

Future<UserReponse> getUser(String userID) async {
  DocumentSnapshot<Map<String, dynamic>> snapshot =
      await db.collection("users").doc(userID).get();

  return UserReponse.fromJson(snapshot);
}
