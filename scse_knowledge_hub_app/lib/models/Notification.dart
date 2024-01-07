class Notification {
  String id;
  String replyId;
  String questionId;
  String questionTitle;
  String senderId;
  String senderName;
  DateTime timestamp;

  Notification({
    required this.id,
    required this.replyId,
    required this.questionId,
    required this.questionTitle,
    required this.senderId,
    required this.senderName,
    required this.timestamp,
  });

  factory Notification.fromJson(Map<String, dynamic> json, String docId) {
    return Notification(
      id: docId,
      replyId: json['reply_id'] ?? '',
      questionId: json['question_id'] ?? '',
      questionTitle: json['question_title'] ?? '',
      senderId: json['sender_id'] ?? '',
      senderName: json['sender_name'] ?? '',
      timestamp: json['timestamp'].toDate(),
    );
  }
}
