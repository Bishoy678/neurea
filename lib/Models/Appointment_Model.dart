class AppointmentModel {
  final String id;
  final String userId;
  final String therapistId;
  final String day;
  final String date;
  final String time;
  final String status;
  final DateTime createdAt;

  AppointmentModel({
    required this.id,
    required this.userId,
    required this.therapistId,
    required this.day,
    required this.date,
    required this.time,
    required this.status,
    required this.createdAt,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      therapistId: json['therapist_id']?.toString() ?? '',
      day: json['day']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      time: json['time']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      createdAt: DateTime.parse(json['created_at'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'therapist_id': therapistId,
      'day': day,
      'date': date,
      'time': time,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }

  bool get isPendingPayment => status == 'pending_payment';
  bool get isConfirmed => status == 'confirmed';
  bool get isCompleted => status == 'completed';
}
