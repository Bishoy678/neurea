class PaymentModel {
  final String id;
  final String userId;
  final String therapistId;
  final double amount;
  final String status;
  final String appointmentDay;
  final String appointmentDate;
  final String appointmentTime;
  final DateTime createdAt;

  PaymentModel({
    required this.id,
    required this.userId,
    required this.therapistId,
    required this.amount,
    required this.status,
    required this.appointmentDay,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.createdAt,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      therapistId: json['therapist_id']?.toString() ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      status: json['status']?.toString() ?? '',
      appointmentDay: json['appointment_day']?.toString() ?? '',
      appointmentDate: json['appointment_date']?.toString() ?? '',
      appointmentTime: json['appointment_time']?.toString() ?? '',
      createdAt: DateTime.parse(json['created_at'].toString()).toLocal(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'therapist_id': therapistId,
      'amount': amount,
      'status': status,
      'appointment_day': appointmentDay,
      'appointment_date': appointmentDate,
      'appointment_time': appointmentTime,
      'created_at': createdAt.toIso8601String(),
    };
  }

  bool get isCompleted => status == 'completed';
}
