class Notification {
  String id;
  String replyId;
  String questionId;
  String senderId;
  String content;
  DateTime timestamp;

  Notification({
    required this.id,
    required this.replyId,
    required this.questionId,
    required this.senderId,
    required this.content,
    required this.timestamp,
  });

  factory Notification.fromJson(Map<String, dynamic> json, String docId) {
    return Notification(
      id: docId,
      replyId: json['reply_id'] ?? '',
      questionId: json['question_id'] ?? '',
      senderId: json['sender _id'] ?? '',
      content: json['content'] ?? '',
      timestamp: json['timestamp'].toDate(),
    );
  }
}
