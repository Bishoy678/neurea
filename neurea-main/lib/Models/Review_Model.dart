class ReviewModel {
  final String id;
  final String userId;
  final String? therapistId;
  final int rating;
  final String content;
  final DateTime createdAt;

  ReviewModel({
    required this.id,
    required this.userId,
    this.therapistId,
    required this.rating,
    required this.content,
    required this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      therapistId: json['therapist_id']?.toString(),
      rating: (json['rating'] as num?)?.toInt() ?? 0,
      content: json['content']?.toString() ?? '',
      createdAt: DateTime.parse(json['created_at'].toString()).toLocal(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'therapist_id': therapistId,
      'rating': rating,
      'content': content,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
