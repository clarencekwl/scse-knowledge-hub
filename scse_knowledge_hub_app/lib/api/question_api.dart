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
    required int numberOfReplies,
    required FieldValue timestamp,
    required bool anonymous}) async {
  Map<String, dynamic> data = {
    "title": title,
    "description": description,
    "likes": likes,
    "numberOfReplies": numberOfReplies,
    "userId": userID,
    "timestamp": timestamp,
    "anonymous": anonymous,
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

Future<ListOfQuestionRepliesReponse?> getAllReplies(
    {required String questionId}) async {
  try {
    CollectionReference questionsCollection =
        FirebaseFirestore.instance.collection('questions');
    DocumentReference questionRef = questionsCollection.doc(questionId);

    QuerySnapshot replySnapshot = await questionRef.collection('replies').get();

    if (replySnapshot.docs.isNotEmpty) {
      return ListOfQuestionRepliesReponse.fromJson(replySnapshot.docs);
    } else {
      return null;
    }
  } catch (e) {
    log("Error fetching replies");
    return null;
  }
}

Future<void> addReply(
    {required String userId,
    required String userName,
    required String questionId,
    required String content,
    String? taggedUserId}) async {
  try {
// Add reply to the "replies" subcollection under the question
    DocumentReference questionReplyRef = await db
        .collection('questions')
        .doc(questionId)
        .collection('replies')
        .add({
      'userId': userId,
      'userName': userName,
      'content': content,
      'timestamp': FieldValue.serverTimestamp(),
      if (taggedUserId != null) 'taggedUserId': taggedUserId,
    });

// Add reply to the "replies" subcollection under the user
    await db
        .collection('users')
        .doc(userId)
        .collection('replies')
        .doc(questionReplyRef.id)
        .set({
      'questionId': questionId,
      'content': content,
      'timestamp': FieldValue.serverTimestamp(),
      if (taggedUserId != null) 'taggedUserId': taggedUserId,
    });
  } catch (e) {
    log('Error creating reply: $e');
  }
}

Future<void> deleteReply(
    {required String userId,
    required String questionId,
    required String replyId}) async {
  try {
    // Delete reply from the "replies" subcollection under the question
    await db
        .collection('questions')
        .doc(questionId)
        .collection('replies')
        .doc(replyId)
        .delete();

    // Delete reply from the "replies" subcollection under the user
    await db
        .collection('users')
        .doc(userId)
        .collection('replies')
        .doc(replyId)
        .delete();
  } catch (e) {
    log('Error deleting reply: $e');
  }
}
