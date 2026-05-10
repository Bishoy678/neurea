class UserActivityModel {
  final String userId;
  final DateTime lastOpen;

  UserActivityModel({required this.userId, required this.lastOpen});

  factory UserActivityModel.fromJson(Map<String, dynamic> json) {
    return UserActivityModel(
      userId: json['user_id']?.toString() ?? '',
      lastOpen: DateTime.parse(json['last_open'].toString()).toLocal(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'user_id': userId, 'last_open': lastOpen.toIso8601String()};
  }
}
