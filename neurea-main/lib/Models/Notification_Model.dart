class NotificationModel {
  final String id;
  final String userId;
  final String title;
  final String description;
  final bool isRead;
  final String type;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.isRead,
    required this.type,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      isRead: json['is_read'] as bool? ?? false,
      type: json['type']?.toString() ?? '',
      createdAt: DateTime.parse(json['created_at'].toString()).toLocal(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'description': description,
      'is_read': isRead,
      'type': type,
      'created_at': createdAt.toIso8601String(),
    };
  }

  NotificationModel copyWith({bool? isRead}) {
    return NotificationModel(
      id: id,
      userId: userId,
      title: title,
      description: description,
      isRead: isRead ?? this.isRead,
      type: type,
      createdAt: createdAt,
    );
  }
}
