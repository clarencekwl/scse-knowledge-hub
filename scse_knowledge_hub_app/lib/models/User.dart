class User {
  String id;
  String name;
  String email;
  DateTime dateJoined;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.dateJoined,
  });

  factory User.fromJson(Map<String, dynamic> json, String docId) {
    return User(
      id: docId,
      name: json['name'],
      email: json['email'],
      dateJoined: json['date_joined'].toDate(),
    );
  }
}
