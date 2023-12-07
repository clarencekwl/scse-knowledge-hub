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
      log("snapshot length is: " + snapshot.docs.length.toString());
      return ListOfQuestionReponse.fromJson(snapshot.docs);
    } else {
      return null;
    }
  } catch (e) {
    log(e.toString());
    return null;
  }
}

Future<ListOfUserQuestionReponse?> getUserQuestionsFromDB(
    {required String userId}) async {
  try {
    // Reference to the user's questions subcollection
    CollectionReference userQuestionsCollection =
        db.collection('users').doc(userId).collection('questions');

    // Get documents from the subcollection
    QuerySnapshot userQuestionsSnapshot = await userQuestionsCollection.get();

    if (userQuestionsSnapshot.docs.isNotEmpty) {
      return ListOfUserQuestionReponse.fromJson(userQuestionsSnapshot.docs);
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
    required int replies,
    required FieldValue timestamp}) async {
  Map<String, dynamic> data = {
    "title": title,
    "description": description,
    "likes": likes,
    "replies": replies,
    "userId": userID,
    "timestamp": timestamp,
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
    await documentReference.update({"title": title}).then(
        (value) => log("Question successfully updated!"),
        onError: (e) => log("Error updating question $e"));
  }
  if (null != description) {
    await documentReference.update({"description": description}).then(
        (value) => log("Question successfully updated!"),
        onError: (e) => log("Error updating question $e"));
  }
}

Future<void> deleteQuestion({required String docId}) async {
  await db.collection("questions").doc(docId).delete().then(
      (value) => log("Question successfully deleted"),
      onError: (e) => log("Error updating question $e"));
}

Future<void> likeQuestion(
    {required String docId, required int numberOfLikes}) async {
  await db.collection("questions").doc(docId).update({"likes": numberOfLikes});
}
