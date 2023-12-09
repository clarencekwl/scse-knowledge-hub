import 'package:cloud_firestore/cloud_firestore.dart';

class Question {
  String id;
  String title;
  String description;
  String userId;
  String userName;
  int? likes;
  int? replies;
  DateTime timestamp;
  bool anonymous;

  Question({
    required this.id,
    required this.title,
    required this.description,
    required this.userId,
    required this.userName,
    this.likes,
    this.replies,
    required this.timestamp,
    required this.anonymous,
  });

  factory Question.fromJson(Map<String, dynamic> json, String docId) {
    return Question(
      id: docId,
      userId: json['userId'],
      userName: '', // Default value, will be replaced by async method
      title: json['title'],
      description: json['description'],
      replies: json['replies'],
      likes: json['likes'],
      timestamp: json['timestamp'].toDate(),
      anonymous: json['anonymous'],
    );
  }

  static Future<Question> createWithUserName(Question question) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    final String userId = question.userId;

    final DocumentSnapshot userSnapshot =
        await firestore.collection('users').doc(userId).get();

    final String userName =
        userSnapshot.exists ? userSnapshot['name'] : 'Unknown User';

    return Question(
        id: question.id,
        userId: userId,
        userName: userName,
        title: question.title,
        description: question.description,
        replies: question.replies,
        likes: question.likes,
        timestamp: question.timestamp,
        anonymous: question.anonymous);
  }

  @override
  String toString() {
    return "{id: $id, user: $userId, title: $title}";
  }
}
