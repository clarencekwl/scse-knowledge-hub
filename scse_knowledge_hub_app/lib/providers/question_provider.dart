import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:cached_memory_image/cached_image_base64_manager.dart';
import 'package:scse_knowledge_hub_app/models/Question.dart';
import 'package:scse_knowledge_hub_app/api/question_api.dart' as QuestionAPI;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scse_knowledge_hub_app/models/Reply.dart';
import 'package:scse_knowledge_hub_app/reponse/question_response.dart';

class QuestionProvider extends ChangeNotifier {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  List<Question> _listOfQuestions = [];
  List<Question> get listOfQuestions => _listOfQuestions;
  set listOfQuestions(List<Question> listOfQuestions) {
    _listOfQuestions = listOfQuestions;
  }

  List<Question> _listOfUserQuestions = [];
  List<Question> get listOfUserQuestions => _listOfUserQuestions;
  set listOfUserQuestions(List<Question> listOfUserQuestions) {
    _listOfUserQuestions = listOfUserQuestions;
  }

  List<Question> _listOfUserRepliedQuestions = [];
  List<Question> get listOfUserRepliedQuestions => _listOfUserRepliedQuestions;
  set listOfUserRepliedQuestions(List<Question> listOfUserQuestions) {
    _listOfUserRepliedQuestions = listOfUserQuestions;
  }

  // List<Question> _listOfUserLikedQuestions = [];
  // List<Question> get listOfUserLikedQuestions => _listOfUserLikedQuestions;
  // set listOfUserLikedQuestions(List<Question> listOfUserLikedQuestions) {
  //   _listOfUserLikedQuestions = listOfUserLikedQuestions;
  // }

  List<Reply> _listOfReplies = [];
  List<Reply> get listOfReplies => _listOfReplies;
  set listOfReplies(List<Reply> listOfReplies) {
    _listOfReplies = listOfReplies;
  }

  Future<void> getQuestions() async {
    startLoading();
    ListOfQuestionReponse? res = await QuestionAPI.getQuestionsFromDB();
    if (null == res) {
      _listOfQuestions = [];
    } else {
      _listOfQuestions = res.listOfQuestions;
    }
    stopLoading();
  }

  Future<void> getUserQuestions(String userId) async {
    startLoading();
    ListOfUserQuestionReponse? res =
        await QuestionAPI.getUserQuestionsFromDB(userId: userId);
    if (null == res) {
      _listOfUserQuestions = [];
    } else {
      _listOfUserQuestions = res.listOfUserQuestions;
    }
    stopLoading();
  }

  Future<void> getUserRepliedQuestions(String userId) async {
    startLoading();
    ListOfUserRepliedQuestionReponse? res =
        await QuestionAPI.getQuestionsRepliedByUserFromDB(userId: userId);
    if (null == res) {
      _listOfUserRepliedQuestions = [];
    } else {
      _listOfUserRepliedQuestions = res.listOfUserRepliedQuestions;
    }
  }

  Future<void> createQuestion({
    required String title,
    required String description,
    required String userID,
    required bool anonymous,
    required String topic,
  }) async {
    startLoading();
    await QuestionAPI.createQuestion(
      title: title,
      description: description,
      userID: userID,
      likes: 0,
      numberOfReplies: 0,
      timestamp: FieldValue.serverTimestamp(),
      anonymous: anonymous,
      topic: topic,
      images: _listOfAttachments,
    );
    await getQuestions();
    await getUserQuestions(userID);
    stopLoading();
  }

  Future<void> updateQuestion({
    required String questionId,
    required String userId,
    required String title,
    required String description,
    required bool anonymous,
    required String topic,
  }) async {
    startLoading();
    await QuestionAPI.updateQuestion(
        questionId: questionId,
        userId: userId,
        title: title,
        description: description,
        anonymous: anonymous,
        topic: topic);
    await getQuestions();
    await getUserQuestions(userId);
    stopLoading();
  }

  Future<void> deleteQuestion(
      {required String docId, required String userId}) async {
    startLoading();
    await QuestionAPI.deleteQuestion(docId: docId, userId: userId);
    await getQuestions();
    await getUserQuestions(userId);
    stopLoading();
  }

  Future<void> getAllRepliesForQuestion({required String questionId}) async {
    listOfReplies = [];
    ListOfQuestionRepliesReponse? res =
        await QuestionAPI.getAllReplies(questionId: questionId);
    if (res != null) {
      listOfReplies = res.listOfQuestionReplies;
    } else {
      listOfReplies = [];
    }
  }

  Future<void> addReply({
    required String userId,
    required String userName,
    required Question question,
    required String content,
    String? taggedUserId,
  }) async {
    startLoading();
    taggedUserId == null
        ? await QuestionAPI.addReply(
            userId: userId,
            userName: userName,
            question: question,
            content: content)
        : await QuestionAPI.addReply(
            userId: userId,
            userName: userName,
            question: question,
            content: content,
            taggedUserId: taggedUserId);
    await QuestionAPI.incrementReplies(question.id, question.userId);
    // Update the List<Question> with the updated number_of_replies
    final updatedQuestionIndex =
        listOfQuestions.indexWhere((q) => q.id == question.id);
    if (updatedQuestionIndex != -1) {
      listOfQuestions[updatedQuestionIndex].numberOfReplies += 1;
    }
    stopLoading();
  }

  Future<void> deleteReply({
    required String userId,
    required Question question,
    required String replyId,
  }) async {
    startLoading();
    await QuestionAPI.deleteReply(
        userId: userId, question: question, replyId: replyId);
    await QuestionAPI.decrementReplies(question.id, question.userId);
    await getAllRepliesForQuestion(questionId: question.id);
    // Update the List<Question> with the updated number_of_replies
    final updatedQuestionIndex =
        listOfQuestions.indexWhere((q) => q.id == question.id);
    if (updatedQuestionIndex != -1) {
      listOfQuestions[updatedQuestionIndex].numberOfReplies -= 1;
    }
    stopLoading();
  }

  List<Uint8List> _listOfAttachments = [];
  List<Uint8List> get listOfAttachments => _listOfAttachments;
  set listOfAttachments(List<Uint8List> listOfAttachements) {
    _listOfAttachments = listOfAttachments;
    notifyListeners();
  }

  //! FUNCTIONS FOR ATTACHEMENTS
  addAttachment(Uint8List annotatedImage) {
    _listOfAttachments.add(annotatedImage);
    log("image added, size of listOfAttachments: ${_listOfAttachments.length}");
    notifyListeners();
  }

  removeAttachment(int imageIndex) {
    _listOfAttachments.removeAt(imageIndex);
    log("image removed, size of listOfAttachments: ${_listOfAttachments.length}");
    notifyListeners();
  }

  removeAllAttachments() {
    _listOfAttachments = [];
    log("all image removed, size of listOfAttachments: ${_listOfAttachments.length}");
    notifyListeners();
  }

  Future clearImageCache() async {
    try {
      await CachedImageBase64Manager.instance().clearCache();
      log('delete cache!');
    } catch (e) {
      log("e: $e");
    }
  }

  // Future<void> likeQuestion(
  //     {required String docId, required int numberOfLikes}) async {
  //   startLoading();
  //   await QuestionAPI.likeQuestion(docId: docId, numberOfLikes: numberOfLikes);
  //   Question question = _listOfQuestions.firstWhere(
  //     (question) => question.id == docId,
  //   );

  //   question.likes = question.likes! + 1;
  // }

  // Future<void> getAllQuestions() async {
  //   for (int i = 0; i < 15; i++) {
  //     _listOfQuestions.add(Question(
  //         id: i.toString(),
  //         title:
  //             _tempListOfTitles[math.Random().nextInt(_tempListOfNames.length)],
  //         user:
  //             _tempListOfNames[math.Random().nextInt(_tempListOfNames.length)],
  //         likes: math.Random().nextInt(100),
  //         replies: math.Random().nextInt(100)));
  //     notifyListeners();
  //   }
  // }

  // final List<String> _tempListOfNames = [
  //   'Clarence Kway',
  //   'Ernest Tan',
  //   'Pang Cheng Feng',
  //   'Bhone Myat Gon',
  //   'Teo Han Hua',
  //   'Xie Zijian'
  // ];

  // final List<String> _tempListOfTitles = [
  //   'CZ2006 Lab 3 documentation',
  //   'MDP Android Bluetooth',
  //   'Database system principles',
  //   'Discrete Math propositional logic',
  //   "CZ4031 don't understand what prof is teaching",
  //   'Help me find the bug in my code!'
  // ];

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  startLoading() {
    _isLoading = true;
    notifyListeners();
  }

  stopLoading() {
    _isLoading = false;
    notifyListeners();
  }

  // Future<void> populateUserLikesCollection() async {
  //   // Reference to the 'questions' collection
  //   final questionsCollection =
  //       FirebaseFirestore.instance.collection('questions');

  //   // Reference to the 'userLikes' collection
  //   final userLikesCollection =
  //       FirebaseFirestore.instance.collection('userLikes');

  //   // Get all documents from the 'questions' collection
  //   final questionsSnapshot = await questionsCollection.get();

  //   // Iterate through each question and populate 'userLikes' collection
  //   for (final questionDoc in questionsSnapshot.docs) {
  //     final questionId = questionDoc.id;

  //     // You can customize this list with user IDs who liked the question
  //     final likedUserIds = [
  //       'bmDrMYHQR4YThCLGFOMY',
  //       'tePv16GUJzUn5F4LkROW',
  //       'XnK9A9EZd0QtuksIhEaD'
  //     ];

  //     // Update 'userLikes' collection for each liked user
  //     for (final userId in likedUserIds) {
  //       await userLikesCollection
  //           .doc(userId)
  //           .set({questionId: true}, SetOptions(merge: true));
  //     }
  //   }
  // }

//   Future<void> populateUserSubCollection() async {
//     final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//     // Get all questions
//     QuerySnapshot questionsSnapshot =
//         await _firestore.collection('questions').get();

// // Iterate through each question
//     for (QueryDocumentSnapshot questionDoc in questionsSnapshot.docs) {
//       // Get userId from the question
//       String? userId = questionDoc.get('userId'); // Use get() instead of data()

//       // Check if userId is not null
//       if (userId != null) {
//         // Get question data
//         Map<String, dynamic> questionData = {
//           'title': questionDoc.get('title'),
//           'description': questionDoc.get('description'),
//           'likes': questionDoc.get('likes'),
//           'replies': questionDoc.get('replies'),
//           'timestamp': questionDoc.get('timestamp'),
//           'userId': questionDoc.get('userId')
//           // Add any other fields you want to include in the user's subcollection
//         };

//         // Add the question to the user's subcollection
//         await _firestore
//             .collection('users')
//             .doc(userId)
//             .collection('questions')
//             .add(questionData);
//       }
//     }
//   }

  // Future<void> updateField() async {
  //   // Update "questions" collection
  //   CollectionReference questionsRef =
  //       FirebaseFirestore.instance.collection('questions');
  //   QuerySnapshot questionsSnapshot = await questionsRef.get();

  //   for (QueryDocumentSnapshot question in questionsSnapshot.docs) {
  //     Map<String, dynamic> data = question.data() as Map<String, dynamic>;
  //     int number_of_replies = data['replies'] ?? 0;

  //     // Update the document
  //     await questionsRef.doc(question.id).update({
  //       'number_of_replies': number_of_replies,
  //     });

  //     // Delete the old field
  //     await questionsRef.doc(question.id).update({
  //       'replies': FieldValue.delete(),
  //     });
  //   }

  //   // Update "questions" subcollections under each user
  //   CollectionReference usersRef =
  //       FirebaseFirestore.instance.collection('users');
  //   QuerySnapshot usersSnapshot = await usersRef.get();

  //   for (QueryDocumentSnapshot user in usersSnapshot.docs) {
  //     CollectionReference userQuestionsRef =
  //         usersRef.doc(user.id).collection('questions');
  //     QuerySnapshot userQuestionsSnapshot = await userQuestionsRef.get();

  //     for (QueryDocumentSnapshot userQuestion in userQuestionsSnapshot.docs) {
  //       Map<String, dynamic> data = userQuestion.data() as Map<String, dynamic>;
  //       int number_of_replies = data['replies'] ?? 0;

  //       // Update the document in the subcollection
  //       await userQuestionsRef.doc(userQuestion.id).update({
  //         'number_of_replies': number_of_replies,
  //       });

  //       // Delete the old field
  //       await userQuestionsRef.doc(userQuestion.id).update({
  //         'replies': FieldValue.delete(),
  //       });
  //     }
  //   }

  //   log('Field name update completed.');
  // }
}
