import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scse_knowledge_hub_app/models/Notification.dart';
import 'package:scse_knowledge_hub_app/models/Question.dart';
import 'package:scse_knowledge_hub_app/models/Reply.dart';

class ListOfQuestionReponse {
  List<Question> listOfQuestions;
  DocumentSnapshot lastDocument;
  ListOfQuestionReponse(
      {required this.listOfQuestions, required this.lastDocument});

  static Future<ListOfQuestionReponse> fromJson(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> json,
      DocumentSnapshot lastDocument) async {
    final List<Question> listOfQuestions = [];

    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in json) {
      final Question question = Question.fromJson(doc.data(), doc.id);
      final Question questionWithUserName =
          await Question.createWithUserName(question);
      listOfQuestions.add(questionWithUserName);
    }

    return ListOfQuestionReponse(
        listOfQuestions: listOfQuestions, lastDocument: lastDocument);
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

class ListOfUserRepliedQuestionReponse {
  List<Question> listOfUserRepliedQuestions;

  ListOfUserRepliedQuestionReponse({required this.listOfUserRepliedQuestions});

  static Future<ListOfUserRepliedQuestionReponse> fromJson(
      List<DocumentSnapshot> json) async {
    List<Question> listOfUserRepliedQuestions = [];

    for (DocumentSnapshot questionDoc in json) {
      // Create a Question object from the question document data
      Question question = Question.fromJson(
          questionDoc.data() as Map<String, dynamic>, questionDoc.id);

      // Asynchronously fetch user name
      Question questionWithUserName =
          await Question.createWithUserName(question);
      listOfUserRepliedQuestions.add(questionWithUserName);
    }
    return ListOfUserRepliedQuestionReponse(
        listOfUserRepliedQuestions: listOfUserRepliedQuestions);
  }
}

class ListOfQuestionRepliesReponse {
  List<Reply> listOfQuestionReplies;

  ListOfQuestionRepliesReponse({required this.listOfQuestionReplies});

  static Future<ListOfQuestionRepliesReponse> fromJson(
      List<QueryDocumentSnapshot<Object?>> json) async {
    List<Reply> listOfQuestionReplies = [];
    for (QueryDocumentSnapshot<Object?> doc in json) {
      Reply reply = Reply.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      listOfQuestionReplies.add(reply);
    }
    return ListOfQuestionRepliesReponse(
        listOfQuestionReplies: listOfQuestionReplies);
  }
}

class ListOfSearchReponse {
  List<Question> listOfSearchQuestions;

  ListOfSearchReponse({required this.listOfSearchQuestions});

  static Future<ListOfSearchReponse> fromJson(var json) async {
    List<Question> listOfSearchQuestions = [];
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in json) {
      Question question = Question.fromJson(doc.data(), doc.id);
      Question questionWithUserName =
          await Question.createWithUserName(question);
      listOfSearchQuestions.add(questionWithUserName);
    }
    return ListOfSearchReponse(listOfSearchQuestions: listOfSearchQuestions);
  }
}

class ListOfNotificationResponse {
  List<Notification> listOfNotifications;
  ListOfNotificationResponse({required this.listOfNotifications});

  static Future<ListOfNotificationResponse> fromJson(var json) async {
    List<Notification> listOfNotifications = [];
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in json) {
      Notification notif = Notification.fromJson(doc.data(), doc.id);
      listOfNotifications.add(notif);
    }
    return ListOfNotificationResponse(listOfNotifications: listOfNotifications);
  }
}

class QuestionResponse {
  Question question;
  QuestionResponse({required this.question});

  static Future<QuestionResponse> fromJson(
      Map<String, dynamic> json, String questionId) async {
    // invoke Factory method of Question Class
    Question question = Question.fromJson(json, questionId);
    // fetch username of the question owner
    Question questionWithUserName = await Question.createWithUserName(question);
    return QuestionResponse(question: questionWithUserName);
  }
}
