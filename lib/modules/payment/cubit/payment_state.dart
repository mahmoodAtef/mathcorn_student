part of 'payment_cubit.dart';

enum PaymentStatus { initial, loading, success, failure }

class PaymentState extends Equatable {
  final PaymentStatus status;
  final List<String>? courses;
  final Exception? exception;
  final String? errorMessage;

  const PaymentState({
    this.status = PaymentStatus.initial,
    this.courses,
    this.exception,
    this.errorMessage,
  });

  PaymentState copyWith({
    PaymentStatus? status,
    List<String>? courses,
    Exception? exception,
    String? errorMessage,
  }) {
    return PaymentState(
      status: status ?? this.status,
      courses: courses ?? this.courses,
      exception: exception ?? this.exception,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, courses, exception, errorMessage];
}

extension PaymentStatusX on PaymentState {
  bool get isInitial => status == PaymentStatus.initial;

  bool get isLoading => status == PaymentStatus.loading;

  bool get isSuccess => status == PaymentStatus.success;

  bool get isFailure => status == PaymentStatus.failure;

  // رسالة خطأ مفصلة للمستخدم
  String get displayErrorMessage {
    if (errorMessage != null) {
      return errorMessage!;
    } else if (exception != null) {
      return exception.toString().replaceAll('Exception: ', '');
    } else {
      return 'حدث خطأ غير متوقع';
    }
  }

  // فحص نوع الخطأ
  bool get isNetworkError {
    final msg = displayErrorMessage.toLowerCase();
    return msg.contains('network') ||
        msg.contains('internet') ||
        msg.contains('connection') ||
        msg.contains('timeout');
  }

  bool get isApiKeyError {
    final msg = displayErrorMessage.toLowerCase();
    return msg.contains('api key') || msg.contains('authentication');
  }

  bool get isPaymentError {
    final msg = displayErrorMessage.toLowerCase();
    return msg.contains('payment') ||
        msg.contains('card') ||
        msg.contains('wallet') ||
        msg.contains('insufficient');
  }

  bool get isValidationError {
    final msg = displayErrorMessage.toLowerCase();
    return msg.contains('required') ||
        msg.contains('invalid') ||
        msg.contains('empty');
  }
}
