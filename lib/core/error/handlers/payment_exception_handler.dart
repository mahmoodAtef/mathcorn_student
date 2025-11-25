import 'package:math_corn/core/error/custom_exceptions/payment_exception.dart';
import 'package:math_corn/core/error/exception_manager.dart';

class PaymentExceptionHandler implements ExceptionHandler {
  @override
  String handle(Exception exception) {
    if (exception is PaymentException) {
      return _getMessageForType(exception.type, exception.message);
    }
    return exception.toString().replaceAll('Exception: ', '');
  }

  @override
  String getIconPath(Exception exception) {
    if (exception is PaymentException) {
      return _getIconForType(exception.type);
    }
    return 'assets/icons/error.svg';
  }

  String _getMessageForType(PaymentErrorType type, String originalMessage) {
    switch (type) {
      case PaymentErrorType.apiKey:
        return 'خطأ في إعدادات نظام الدفع - يرجى المحاولة لاحقاً';
      case PaymentErrorType.network:
        return 'خطأ في الاتصال بالإنترنت - يرجى التحقق من اتصالك';
      case PaymentErrorType.paymentFailed:
        return 'فشلت عملية الدفع - يرجى التحقق من بيانات الدفع';
      case PaymentErrorType.insufficientFunds:
        return 'الرصيد غير كافي لإتمام العملية';
      case PaymentErrorType.invalidCard:
        return 'بيانات الكارت غير صحيحة';
      case PaymentErrorType.expired:
        return 'انتهت صلاحية بيانات الدفع';
      case PaymentErrorType.timeout:
        return 'انتهت مهلة العملية - يرجى المحاولة مرة أخرى';
      case PaymentErrorType.wallet:
        return 'خطأ في بيانات المحفظة الإلكترونية';
      case PaymentErrorType.fileUpload:
        return 'خطأ في رفع الملف - يرجى اختيار ملف آخر';
      case PaymentErrorType.accessRequest:
        return 'خطأ في إنشاء طلب الوصول - يرجى المحاولة مرة أخرى';
      case PaymentErrorType.initialization:
        return 'خطأ في تهيئة نظام الدفع';
      case PaymentErrorType.general:
      default:
        return originalMessage;
    }
  }

  String _getIconForType(PaymentErrorType type) {
    switch (type) {
      case PaymentErrorType.network:
        return 'assets/icons/no_internet.svg';
      case PaymentErrorType.paymentFailed:
      case PaymentErrorType.invalidCard:
      case PaymentErrorType.insufficientFunds:
        return 'assets/icons/payment_error.svg';
      case PaymentErrorType.timeout:
        return 'assets/icons/timeout.svg';
      case PaymentErrorType.wallet:
        return 'assets/icons/wallet_error.svg';
      case PaymentErrorType.fileUpload:
        return 'assets/icons/file_error.svg';
      default:
        return 'assets/icons/error.svg';
    }
  }
}
