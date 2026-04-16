class MoodModel {
  final String id;
  final String userId;
  final String mood;
  final DateTime createdAt;

  MoodModel({
    required this.id,
    required this.userId,
    required this.mood,
    required this.createdAt,
  });

  factory MoodModel.fromJson(Map<String, dynamic> json) {
    return MoodModel(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      mood: json['mood']?.toString() ?? '',
      createdAt: DateTime.parse(json['created_at'].toString()).toLocal(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'mood': mood,
      'created_at': createdAt.toIso8601String(),
    };
  }

  bool get isNegative => mood == 'Sad' || mood == 'Angry';

  bool get isToday {
    final now = DateTime.now();
    return createdAt.year == now.year &&
        createdAt.month == now.month &&
        createdAt.day == now.day;
  }
}
