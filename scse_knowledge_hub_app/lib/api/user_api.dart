import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scse_knowledge_hub_app/reponse/user_response.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;

Future<UserResponse> getUser({required String userID}) async {
  DocumentSnapshot<Map<String, dynamic>> snapshot =
      await db.collection("users").doc(userID).get();

  return UserResponse.fromJson(snapshot);
}

Future<void> createUser(
    {required String userID,
    required String userName,
    required String userEmail}) async {
  Map<String, dynamic> data = {
    "name": userName,
    "email": userEmail,
    "date_joined": FieldValue.serverTimestamp(),
  };
  await db.collection("users").doc(userID).set(data);
}

Future<void> changeUsername(
    {required String userId, required String newUsername}) async {
  // Update 'users' subcollection
  final userRef = db.collection('users').doc(userId);
  await db.runTransaction((transaction) async {
    final userQuestionDoc = await transaction.get(userRef);
    if (userQuestionDoc.exists) {
      transaction.update(
        userRef,
        {'name': newUsername},
      );
    }
  });
}
