class Question {
  String id;
  String title;
  String description;
  String user;
  int? likes;
  int? replies;

  Question({
    required this.id,
    required this.title,
    required this.description,
    required this.user,
    this.likes,
    this.replies,
  });

  factory Question.fromJson(Map<String, dynamic> json, String docId) {
    return Question(
      id: docId,
      user: json['userId'],
      title: json['title'],
      description: json['description'],
      replies: json['replies'],
      likes: json['likes'],
    );
  }

  @override
  String toString() {
    return "{id: $id, user: $user, title: $title}";
  }
}
