import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:cached_memory_image/cached_image_base64_manager.dart';
import 'package:flutter/material.dart';
import 'package:scse_knowledge_hub_app/models/Question.dart';
import 'package:scse_knowledge_hub_app/api/question_api.dart' as QuestionAPI;
import 'package:cloud_firestore/cloud_firestore.dart';
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

  Future<void> getQuestions() async {
    startLoading();
    ListOfQuestionReponse? res = await QuestionAPI.getQuestionsFromDB();
    if (null == res) {
      _listOfQuestions = [];
    } else {
      _listOfQuestions = res.listofQuestions;
    }
    stopLoading();
  }

  void getUserQuestions(String userId) {
    startLoading();
    log("user id is: $userId");
    for (int i = 0; i < _listOfQuestions.length; i++) {
      log("question's user id is: ${_listOfQuestions[i].userId}");
      if (userId == _listOfQuestions[i].userId) {
        _listOfUserQuestions.add(_listOfQuestions[i]);
      }
    }
    stopLoading();
  }

  Future<void> createQuestion(
      {required String title,
      required String description,
      required String userID}) async {
    startLoading();
    await QuestionAPI.createQuestion(
      title: title,
      description: description,
      userID: userID,
      likes: 0,
      replies: 0,
    );
    await getQuestions();
    _listOfUserQuestions.clear();
    stopLoading();
  }

  Future<void> updateQuestion(
      {required String docID, String? title, String? description}) async {
    startLoading();
    await QuestionAPI.updateQuestion(
        docId: docID, title: title, description: description);
    await getQuestions();
    _listOfUserQuestions.clear();
    stopLoading();
  }

  Future<void> deleteQuestion({required String docId}) async {
    startLoading();
    await QuestionAPI.deleteQuestion(docId: docId);
    await getQuestions();
    _listOfUserQuestions.clear();
    stopLoading();
  }

  List<Uint8List> _listOfAttachments = [];
  List<Uint8List> get listOfAttachments => _listOfAttachments;
  set listOfAttachments(List<Uint8List> listOfAttachements) {
    _listOfAttachments = listOfAttachments;
    notifyListeners();
  }

  //! TEMP: FUNCTIONS FOR ATTACHEMENTS
  addAttachment(Uint8List annotatedImage) {
    _listOfAttachments.add(annotatedImage);
    notifyListeners();
  }

  removeAttachment(int imageIndex) {
    _listOfAttachments.removeAt(imageIndex);
    notifyListeners();
  }

  removeAllAttachments() {
    _listOfAttachments = [];
    notifyListeners();
  }

  clearImageCache() async {
    try {
      await CachedImageBase64Manager.instance().clearCache();
      log('delete cache!');
    } catch (e) {
      log("e: $e");
    }
  }

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
}
