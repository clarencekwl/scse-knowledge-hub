import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scse_knowledge_hub_app/reponse/question_response.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;

Future<ListOfQuestionReponse?> getQuestionsFromDB() async {
  QuerySnapshot<Map<String, dynamic>> snapshot =
      await db.collection("questions").get();
  if (snapshot.docs.isNotEmpty) {
    return ListOfQuestionReponse.fromJson(snapshot.docs);
  } else {
    return null;
  }
}

Future<void> createQuestion(
    {required String title,
    required String description,
    required String userID,
    required int likes,
    required int replies}) async {
  Map<String, dynamic> data = {
    "title": title,
    "description": description,
    "likes": likes,
    "replies": replies,
    "userId": userID,
  };

  // ignore: unused_local_variable
  DocumentReference<Map<String, dynamic>> snapshot =
      await db.collection("questions").add(data);
}

Future<void> updateQuestion(
    {required String docId, String? title, String? description}) async {
  if (null != title) {
    db.collection("questions").doc(docId).update({"title": title}).then(
        (value) => log("DocumentSnapshot successfully updated!"),
        onError: (e) => log("Error updating document $e"));
  }
  if (null != description) {
    db
        .collection("questions")
        .doc(docId)
        .update({"description": description}).then(
            (value) => log("DocumentSnapshot successfully updated!"),
            onError: (e) => log("Error updating document $e"));
  }
}

// String generateRandomID() {
//   final random = math.Random();
//   const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';

//   String id = '';

//   for (int i = 0; i < 20; i++) {
//     final index = random.nextInt(characters.length);
//     id += characters[index];
//   }

//   return id;
// }
