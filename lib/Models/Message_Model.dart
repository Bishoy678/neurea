class MessageModel {
  final String id;
  final String userId;
  final String therapistId;
  final String content;
  final bool isSent;
  final DateTime createdAt;

  MessageModel({
    required this.id,
    required this.userId,
    required this.therapistId,
    required this.content,
    required this.isSent,
    required this.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      therapistId: json['therapist_id']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      isSent: json['is_sent'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'].toString()).toLocal(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'therapist_id': therapistId,
      'content': content,
      'is_sent': isSent,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
