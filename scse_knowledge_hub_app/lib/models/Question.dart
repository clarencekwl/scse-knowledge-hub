class Question {
  int id;
  String title;
  String description;
  String user;
  int likes;
  int replies;

  Question({
    required this.id,
    required this.title,
    required this.description,
    required this.user,
    required this.likes,
    required this.replies,
  });
}
