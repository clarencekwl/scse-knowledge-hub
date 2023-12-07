import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scse_knowledge_hub_app/reponse/question_response.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;

Future<ListOfQuestionReponse?> getQuestionsFromDB() async {
  try {
    QuerySnapshot<Map<String, dynamic>> snapshot = await db
        .collection("questions")
        .orderBy('timestamp', descending: true)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return ListOfQuestionReponse.fromJson(snapshot.docs);
    } else {
      return null;
    }
  } catch (e) {
    log(e.toString());
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
  DocumentReference<Map<String, dynamic>> documentReference =
      db.collection("questions").doc(docId);

  if (null != title) {
    documentReference.update({"title": title}).then(
        (value) => log("Question successfully updated!"),
        onError: (e) => log("Error updating question $e"));
  }
  if (null != description) {
    documentReference.update({"description": description}).then(
        (value) => log("Question successfully updated!"),
        onError: (e) => log("Error updating question $e"));
  }
}

Future<void> deleteQuestion({required String docId}) async {
  db.collection("questions").doc(docId).delete().then(
      (value) => log("Question successfully deleted"),
      onError: (e) => log("Error updating question $e"));
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
