class User {
  String id;
  String name;
  String email;

  User({
    required this.id,
    required this.name,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json, String docId) {
    return User(
      id: docId,
      name: json['name'],
      email: json['email'],
    );
  }
}
