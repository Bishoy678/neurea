class OnboardingAnswersModel {
  final String id;
  final String userId;
  final String mainGoal;
  final String additionalGoal;
  final String currentFeeling;
  final String? meditationExperience;
  final String accountStatus;
  final String dailyRhythm;
  final DateTime createdAt;

  OnboardingAnswersModel({
    required this.id,
    required this.userId,
    required this.mainGoal,
    required this.additionalGoal,
    required this.currentFeeling,
    this.meditationExperience,
    required this.accountStatus,
    required this.dailyRhythm,
    required this.createdAt,
  });

  factory OnboardingAnswersModel.fromJson(Map<String, dynamic> json) {
    return OnboardingAnswersModel(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      mainGoal: json['main_goal']?.toString() ?? '',
      additionalGoal: json['additional_goal']?.toString() ?? '',
      currentFeeling: json['current_feeling']?.toString() ?? '',
      meditationExperience: json['meditation_experience']?.toString(),
      accountStatus: json['account_status']?.toString() ?? '',
      dailyRhythm: json['daily_rhythm']?.toString() ?? '',
      createdAt: DateTime.parse(json['created_at'].toString()).toLocal(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'main_goal': mainGoal,
      'additional_goal': additionalGoal,
      'current_feeling': currentFeeling,
      'meditation_experience': meditationExperience,
      'account_status': accountStatus,
      'daily_rhythm': dailyRhythm,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
