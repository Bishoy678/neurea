abstract class PaymentState {}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentSuccess extends PaymentState {
  final String message;
  
  PaymentSuccess({this.message = 'Payment Successful!'});
}

class PaymentError extends PaymentState {
  final String message;
  
  PaymentError(this.message);
}