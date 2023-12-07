import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scse_knowledge_hub_app/models/Question.dart';

class ListOfQuestionReponse {
  List<Question> listOfQuestions;

  ListOfQuestionReponse({required this.listOfQuestions});

  static Future<ListOfQuestionReponse> fromJson(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> json) async {
    final List<Question> listOfQuestions = [];

    for (QueryDocumentSnapshot<Map<String, dynamic>> e in json) {
      final Question question = Question.fromJson(e.data(), e.id);
      final Question questionWithUserName =
          await Question.createWithUserName(question);
      listOfQuestions.add(questionWithUserName);
    }

    return ListOfQuestionReponse(listOfQuestions: listOfQuestions);
  }
}

class ListOfUserQuestionReponse {
  List<Question> listOfUserQuestions;

  ListOfUserQuestionReponse({required this.listOfUserQuestions});

  static Future<ListOfUserQuestionReponse> fromJson(
      List<QueryDocumentSnapshot<Object?>> json) async {
    List<Question> listOfUserQuestions = [];

    // Iterate through each document and convert it to a Question
    for (QueryDocumentSnapshot<Object?> doc in json) {
      Question question =
          Question.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      Question questionWithUserName =
          await Question.createWithUserName(question);
      listOfUserQuestions.add(questionWithUserName);
    }

    return ListOfUserQuestionReponse(listOfUserQuestions: listOfUserQuestions);
  }
}
