import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scse_knowledge_hub_app/models/Question.dart';

class ListOfQuestionReponse {
  List<Question> listofQuestions;

  ListOfQuestionReponse({required this.listofQuestions});

  static Future<ListOfQuestionReponse> fromJson(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> json) async {
    final List<Question> listOfQuestions = [];

    for (QueryDocumentSnapshot<Map<String, dynamic>> e in json) {
      final Question question = Question.fromJson(e.data(), e.id);
      final Question questionWithUserName =
          await Question.createWithUserName(question);
      listOfQuestions.add(questionWithUserName);
    }

    return ListOfQuestionReponse(listofQuestions: listOfQuestions);
  }
}
