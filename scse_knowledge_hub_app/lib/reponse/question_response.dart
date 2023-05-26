import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scse_knowledge_hub_app/models/Question.dart';

class ListOfQuestionReponse {
  List<Question> listofQuestions;

  ListOfQuestionReponse({required this.listofQuestions});

  factory ListOfQuestionReponse.fromJson(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> json) {
    // List<dynamic>? list = json.map((e) => e.data()).toList();
    return ListOfQuestionReponse(
        listofQuestions:
            json.map((e) => Question.fromJson(e.data(), e.id)).toList());
  }
}
