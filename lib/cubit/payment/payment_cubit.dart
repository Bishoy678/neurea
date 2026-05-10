import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neurea/core/presentation/screens/Notification_Helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {

  static bool testMode = false;
  static bool forceError = false;

  PaymentCubit() : super(PaymentInitial());

  Future<void> confirmPayment({
    required String therapistId,
    required String therapistName,
    required String therapistImage,
    required String specialty,
    required String appointmentDay,
    required String appointmentDate,
    required String appointmentTime,
    required double price,
    String? cardNumber,
    String? cardHolder,
    String? expiry,
    String? cvc,
  }) async {
    emit(PaymentLoading());

    if (testMode && forceError) {
      await Future.delayed(const Duration(seconds: 1));
      emit(PaymentError('Test Error: Payment failed intentionally. Please try again later.'));
      return;
    }
    
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) {
        emit(PaymentError('User not logged in. Please login and try again.'));
        return;
      }

      await Supabase.instance.client.from('payments').insert({
        'user_id': userId,
        'therapist_id': therapistId,
        'therapist_name': therapistName,
        'therapist_image': therapistImage,
        'therapist_specialty': specialty,
        'amount': price,
        'status': 'completed',
        'appointment_day': appointmentDay,
        'appointment_date': appointmentDate,
        'appointment_time': appointmentTime,
      });

      await NotificationHelper.send(
        title: 'Payment Successful 💳',
        description:
            'Your payment of \$$price for the session with $therapistName on $appointmentDay at $appointmentTime is confirmed.',
        type: 'reminder',
      );

      emit(PaymentSuccess(
        message: 'Payment Successful! Your appointment has been booked successfully.',
      ));
    } catch (e) {
    
      emit(PaymentError(
        'Failed to confirm payment. Please try again later.\nError: ${e.toString()}',
      ));
    }
  }
} 


