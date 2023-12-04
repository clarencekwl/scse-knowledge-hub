import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:cached_memory_image/cached_image_base64_manager.dart';
import 'package:flutter/material.dart';
import 'package:scse_knowledge_hub_app/models/Question.dart';
import 'package:scse_knowledge_hub_app/api/question_api.dart' as QuestionAPI;
import 'package:scse_knowledge_hub_app/api/user_api.dart' as UserAPI;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scse_knowledge_hub_app/models/User.dart';
import 'package:scse_knowledge_hub_app/reponse/question_response.dart';
import 'package:scse_knowledge_hub_app/reponse/user_response.dart';

class QuestionProvider extends ChangeNotifier {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  List<Question> _listOfQuestions = [];
  List<Question> get listOfQuestions => _listOfQuestions;
  set listOfQuestions(List<Question> listOfQuestions) {
    _listOfQuestions = listOfQuestions;
  }

  Future<void> getQuestions() async {
    startLoading();
    ListOfQuestionReponse? res = await QuestionAPI.getQuestionsFromDB();
    if (null == res) {
      _listOfQuestions = [];
    } else {
      _listOfQuestions = res.listofQuestions;
    }
    for (int i = 0; i < _listOfQuestions.length; i++) {
      UserReponse res = await UserAPI.getUser(userID: _listOfQuestions[i].user);
      User user = res.user;
      _listOfQuestions[i].user = user.name;
      if (_listOfQuestions[i].likes == null) {
        _listOfQuestions[i].likes = math.Random().nextInt(100);
      }
      if (_listOfQuestions[i].replies == null) {
        _listOfQuestions[i].replies = math.Random().nextInt(100);
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
      title: _tempListOfTitles[math.Random().nextInt(_tempListOfNames.length)],
      description: description,
      userID: userID,
      likes: math.Random().nextInt(100),
      replies: math.Random().nextInt(100),
    );
    await getQuestions();
    stopLoading();
  }

  Future<void> updateQuestion(
      {required String docID, String? title, String? description}) async {
    startLoading();
    await QuestionAPI.updateQuestion(
        docId: docID,
        title:
            _tempListOfTitles[math.Random().nextInt(_tempListOfNames.length)],
        description: description);
    await getQuestions();
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

  final List<String> _tempListOfNames = [
    'Clarence Kway',
    'Ernest Tan',
    'Pang Cheng Feng',
    'Bhone Myat Gon',
    'Teo Han Hua',
    'Xie Zijian'
  ];

  final List<String> _tempListOfTitles = [
    'CZ2006 Lab 3 documentation',
    'MDP Android Bluetooth',
    'Database system principles',
    'Discrete Math propositional logic',
    "CZ4031 don't understand what prof is teaching",
    'Help me find the bug in my code!'
  ];

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
