class User {
  String id;
  String name;
  String email;
  DateTime dateJoined;
  int noOfQuestions;
  int noOfQuestionsReplied;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.dateJoined,
    required this.noOfQuestions,
    required this.noOfQuestionsReplied,
  });

  factory User.fromJson(Map<String, dynamic> json, String docId) {
    return User(
        id: docId,
        name: json['name'],
        email: json['email'],
        dateJoined: json['date_joined'].toDate(),
        noOfQuestions: json['no_of_questions'] ?? 0,
        noOfQuestionsReplied: json['no_of_questions_replied'] ?? 0);
  }
}
