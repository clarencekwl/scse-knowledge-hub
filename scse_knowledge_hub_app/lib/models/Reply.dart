class Reply {
  String id;
  String userId;
  String userName;
  String content;
  DateTime timestamp;
  String? taggedUserId; // Tagged user ID

  Reply({
    required this.id,
    required this.userId,
    required this.userName,
    required this.content,
    required this.timestamp,
    required this.taggedUserId,
  });

  factory Reply.fromMap(String replyId, Map<String, dynamic> json) {
    return Reply(
      id: replyId,
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      content: json['content'] ?? '',
      timestamp: json['timestamp'].toDate(),
      taggedUserId: json['taggedUserId'],
    );
  }
}
