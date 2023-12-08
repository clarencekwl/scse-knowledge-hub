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

  try {
    // Add the question to the 'questions' collection
    DocumentReference<Map<String, dynamic>> questionDocRef =
        await db.collection("questions").add(data);

    // Add the question to the user's 'questions' subcollection
    await db
        .collection("users")
        .doc(userID)
        .collection("questions")
        .doc(questionDocRef.id)
        .set(data);

    log('Question created successfully with ID: ${questionDocRef.id}');
  } catch (e) {
    log('Error creating question: $e');
  }
}

Future<void> updateQuestion(
    {required String docId, String? title, String? description}) async {
  try {
    if (null != title) {
      await db.collection("questions").doc(docId).update({"title": title});
      await db
          .collection("users")
          .doc(docId)
          .collection('questions')
          .doc(docId)
          .update({"title": title});
    }
    if (null != description) {
      await db
          .collection("questions")
          .doc(docId)
          .update({"description": description});
      await db
          .collection("users")
          .doc(docId)
          .collection('questions')
          .doc(docId)
          .update({"description": description});
    }
    log('Question updated successfully');
  } catch (e) {
    log('Error updating question: $e');
  }
}

Future<void> deleteQuestion(
    {required String docId, required String userId}) async {
  try {
    // Delete from 'questions' collection
    await db.collection('questions').doc(docId).delete();

    // Delete from user's 'questions' subcollection
    await db
        .collection('users')
        .doc(userId)
        .collection('questions')
        .doc(docId)
        .delete();

    log('Question deleted successfully');
  } catch (e) {
    log('Error deleting question: $e');
  }
}

Future<void> likeQuestion(
    {required String docId, required int numberOfLikes}) async {
  await db.collection("questions").doc(docId).update({"likes": numberOfLikes});
}
