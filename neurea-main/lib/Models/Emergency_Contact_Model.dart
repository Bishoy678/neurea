class EmergencyContactModel {
  final String id;
  final String userId;
  final String phone;
  final DateTime createdAt;

  EmergencyContactModel({
    required this.id,
    required this.userId,
    required this.phone,
    required this.createdAt,
  });

  factory EmergencyContactModel.fromJson(Map<String, dynamic> json) {
    return EmergencyContactModel(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      createdAt: DateTime.parse(json['created_at'].toString()).toLocal(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'phone': phone,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
