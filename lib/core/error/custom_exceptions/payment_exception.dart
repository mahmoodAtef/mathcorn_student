import 'package:math_corn/core/error/exception_manager.dart';

class PaymentException implements Exception {
  final String message;
  final PaymentErrorType type;

  PaymentException({
    required this.message,
    this.type = PaymentErrorType.general,
  });

  @override
  String toString() => message;
}

enum PaymentErrorType {
  general,
  apiKey,
  network,
  paymentFailed,
  insufficientFunds,
  invalidCard,
  expired,
  timeout,
  wallet,
  fileUpload,
  accessRequest,
  initialization,
}

