import 'package:flutter/material.dart';
import 'package:scse_knowledge_hub_app/models/Question.dart';
import 'dart:math';

class QuestionProvider extends ChangeNotifier {
  List<Question> _listOfQuestions = [];
  List<Question> get listOfQuestions => _listOfQuestions;
  set listOfQuestions(List<Question> listOfQuestions) {
    _listOfQuestions = listOfQuestions;
  }

  Future<void> getAllQuestions() async {
    for (int i = 0; i < 15; i++) {
      _listOfQuestions.add(Question(
          id: i,
          title: _tempListOfTitles[Random().nextInt(_tempListOfNames.length)],
          description:
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliquaadasdasdasdas dasdasdasdas dasdasdasdasd asdasdad dasd aasdasd asdasda sdaa dasd dsd sd s",
          user: _tempListOfNames[Random().nextInt(_tempListOfNames.length)],
          likes: Random().nextInt(100),
          replies: Random().nextInt(100)));
      notifyListeners();
    }
  }

  List<String> _tempListOfNames = [
    'Clarence Kway',
    'Ernest Tan',
    'Pang Cheng Feng',
    'Bhone Myat Gon',
    'Teo Han Hua',
    'Xie Zijian'
  ];

  List<String> _tempListOfTitles = [
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
