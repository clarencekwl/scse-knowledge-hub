import 'dart:developer';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:scse_knowledge_hub_app/models/Question.dart';
import 'package:scse_knowledge_hub_app/reponse/question_response.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;

//! START <<CRUD FOR QUESTIONS>> START
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
    QuerySnapshot userQuestionsSnapshot = await userQuestionsCollection
        .orderBy('timestamp', descending: true)
        .get();

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

Future<ListOfUserRepliedQuestionReponse?> getQuestionsRepliedByUserFromDB(
    {required String userId}) async {
  try {
    // Get user document
    DocumentSnapshot userDoc = await db.collection('users').doc(userId).get();

    // Check if user document exists
    if (userDoc.exists) {
      // Get replies subcollection
      QuerySnapshot repliesSnapshot = await userDoc.reference
          .collection('replies')
          .orderBy('timestamp', descending: true)
          .get();

      // Compile a list of question documents (DocumentSnapshot)
      List<DocumentSnapshot> listOfQuestionDocs = [];

      for (QueryDocumentSnapshot replyDoc in repliesSnapshot.docs) {
        String questionId = replyDoc['questionId'];

        // Check if the question ID is already present in the list
        bool questionExists =
            listOfQuestionDocs.any((doc) => doc.id == questionId);

        if (!questionExists) {
          // Get question document and add to the list
          DocumentSnapshot questionDoc =
              await db.collection('questions').doc(questionId).get();

          if (questionDoc.exists && questionDoc['userId'] != userId) {
            listOfQuestionDocs.add(questionDoc);
          }
        }
      }
      if (listOfQuestionDocs.isNotEmpty) {
        return ListOfUserRepliedQuestionReponse.fromJson(listOfQuestionDocs);
      }
    }
    return null;
  } catch (e) {
    log('Error fetching questions: $e');
    return null;
  }
}

Future<void> createQuestion({
  required String title,
  required String description,
  required String userID,
  required int likes,
  required int numberOfReplies,
  required FieldValue timestamp,
  required bool anonymous,
  required List<Uint8List> images,
}) async {
  log("size of image: ${images.length}");
  Map<String, dynamic> data = {
    "title": title,
    "description": description,
    "likes": likes,
    "number_of_replies": numberOfReplies,
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

    if (images.isNotEmpty) {
      // Call uploadImages with the question ID and images
      List<String> imageUrls = await uploadImages(questionDocRef.id, images);

      // Call updateQuestionWithImageUrls to update the Firestore document with image URLs
      await updateQuestionWithImageUrls(userID, questionDocRef.id, imageUrls);
    }
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
    // Get the list of image URLs associated with the question
    final questionDoc = await db.collection('questions').doc(docId).get();
    final List<dynamic>? imageUrls = questionDoc['image_urls'];

    // Delete images from Firebase Cloud Storage
    if (imageUrls != null && imageUrls.isNotEmpty) {
      await deleteImagesFromStorage(imageUrls);
    }

    // Delete from 'questions' collection
    await db.collection('questions').doc(docId).delete();

    // Delete from user's 'questions' subcollection
    await db
        .collection('users')
        .doc(userId)
        .collection('questions')
        .doc(docId)
        .delete();

    log('Question and associated images deleted successfully');
  } catch (e) {
    log('Error deleting question: $e');
  }
}

//! END <<CRUD FOR QUESTIONS>> END

//! START <<FUCNTIONS FOR REPLY>> START
Future<ListOfQuestionRepliesReponse?> getAllReplies(
    {required String questionId}) async {
  try {
    CollectionReference questionsCollection =
        FirebaseFirestore.instance.collection('questions');
    DocumentReference questionRef = questionsCollection.doc(questionId);

    QuerySnapshot replySnapshot = await questionRef
        .collection('replies')
        .orderBy('timestamp', descending: false)
        .get();

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
    required Question question,
    required String content,
    String? taggedUserId}) async {
  try {
// Add reply to the "replies" subcollection under the question
    DocumentReference questionReplyRef = await db
        .collection('questions')
        .doc(question.id)
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
      'questionId': question.id,
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
    required Question question,
    required String replyId}) async {
  try {
    // Delete reply from the "replies" subcollection under the question
    await db
        .collection('questions')
        .doc(question.id)
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

Future<void> incrementReplies(String questionId, String userId) async {
  await _updateReplies(questionId, userId, 1);
}

Future<void> decrementReplies(String questionId, String userId) async {
  await _updateReplies(questionId, userId, -1);
}

Future<void> _updateReplies(
    String questionId, String userId, int change) async {
  // Update 'questions' collection
  final questionRef = db.collection('questions').doc(questionId);
  await db.runTransaction((transaction) async {
    final questionDoc = await transaction.get(questionRef);
    if (questionDoc.exists) {
      final currentReplies = questionDoc['number_of_replies'] ?? 0;
      transaction.update(
        questionRef,
        {'number_of_replies': currentReplies + change},
      );
    }
  });

  // Update 'users' subcollection
  final userRef = db
      .collection('users')
      .doc(userId)
      .collection('questions')
      .doc(questionId);
  await db.runTransaction((transaction) async {
    final userQuestionDoc = await transaction.get(userRef);
    if (userQuestionDoc.exists) {
      final currentReplies = userQuestionDoc['number_of_replies'] ?? 0;
      transaction.update(
        userRef,
        {'number_of_replies': currentReplies + change},
      );
    }
  });
}
//! END <<FUCNTIONS FOR REPLY>> END

//! START <<FUNCTIONS FOR ATTACHMENTS>> START
Future<List<String>> uploadImages(
    String questionId, List<Uint8List> images) async {
  List<String> imageUrls = [];

  for (var i = 0; i < images.length; i++) {
    final Uint8List imageBytes = images[i];
    final List<int> byteList = imageBytes.cast<int>().toList();
    final String filePath = 'question_images/$questionId/image_$i.jpg';

    try {
      final storageRef =
          firebase_storage.FirebaseStorage.instance.ref().child(filePath);

      // Upload image data to Firebase Cloud Storage
      await storageRef.putData(Uint8List.fromList(byteList));

      // Get the download URL for the uploaded image
      final imageUrl = await storageRef.getDownloadURL();
      imageUrls.add(imageUrl);
    } catch (e) {
      log('Error uploading image $i: $e');
      // Handle error, you might want to throw an exception or log the error
    }
  }

  log('Images uploaded successfully.');

  return imageUrls;
}

Future<void> updateQuestionWithImageUrls(
    String userId, String questionId, List<String> imageUrls) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    await firestore
        .collection('questions')
        .doc(questionId)
        .update({'image_urls': imageUrls});
    log('Question updated with image URLs.');

    await firestore
        .collection('users')
        .doc(userId) // Replace with the appropriate user ID
        .collection('questions')
        .doc(questionId)
        .update({'image_urls': imageUrls});
  } catch (e) {
    log('Error updating question with image URLs: $e');
    // Handle error, you might want to throw an exception or log the error
  }
}

Future<void> deleteImagesFromStorage(List<dynamic> imageUrls) async {
  try {
    final firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;

    for (String imageUrl in imageUrls) {
      final firebase_storage.Reference imageRef = storage.refFromURL(imageUrl);
      await imageRef.delete();
      log('Image deleted successfully: $imageUrl');
    }
  } catch (e) {
    log('Error deleting images from storage: $e');
    // Handle error, you might want to throw an exception or log the error
  }
}
//! END <<FUNCTIONS FOR ATTACHMENTS>> END