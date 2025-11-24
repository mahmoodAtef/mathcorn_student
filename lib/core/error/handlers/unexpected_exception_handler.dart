import 'dart:async';

import 'package:math_corn/core/error/custom_exceptions/internet_exception.dart';
import 'package:math_corn/core/error/exception_manager.dart';
import 'package:math_corn/core/services/localization_manager.dart';
import 'package:math_corn/core/utils/assets_manager.dart';

class UnexpectedExceptionHandler implements ExceptionHandler {
  @override
  String handle(Exception exception) {
    final isArabic =
        LocalizationManager.getCurrentLocale().languageCode == 'ar';

    // Handle specific exception types with appropriate messages
    if (exception is FormatException) {
      return isArabic ? "خطأ في تنسيق البيانات" : "Data format error";
    }

    if (exception is TimeoutException) {
      return isArabic ? "انتهت مهلة العملية" : "Operation timeout";
    }

    if (exception is StateError) {
      return isArabic ? "خطأ في حالة التطبيق" : "Application state error";
    }

    if (exception is ArgumentError) {
      return isArabic ? "خطأ في المعطيات المُدخلة" : "Invalid input arguments";
    }

    if (exception is RangeError) {
      return isArabic ? "خطأ في النطاق المحدد" : "Range error";
    }

    if (exception is UnsupportedError) {
      return isArabic ? "عملية غير مدعومة" : "Unsupported operation";
    }

    if (exception is UnimplementedError) {
      return isArabic ? "ميزة غير مطبقة بعد" : "Feature not implemented yet";
    }

    if (exception is AssertionError) {
      return isArabic ? "خطأ في التحقق من الشروط" : "Assertion failed";
    }

    if (exception is ConcurrentModificationError) {
      return isArabic
          ? "تعديل متزامن غير مسموح"
          : "Concurrent modification error";
    }

    if (exception is NoSuchMethodError) {
      return isArabic ? "الطريقة المطلوبة غير موجودة" : "Method not found";
    }
    if (exception is InternetException) {
      return isArabic ? "لا يتوفر اتصال بالإنترنت" : "No internet connection";
    }

    // Default unexpected error message
    return isArabic ? "حدث خطأ غير متوقع" : "Unexpected error occurred";
  }

  @override
  String getIconPath(Exception exception) {
    // Return specific icons based on exception type
    if (exception is FormatException) {
      return AssetsManager.badRequestError;
    }

    if (exception is TimeoutException) {
      return AssetsManager.noInternetConnection;
    }

    if (exception is StateError || exception is AssertionError) {
      return AssetsManager.internalServerError;
    }

    if (exception is ArgumentError || exception is RangeError) {
      return AssetsManager.badRequestError;
    }

    if (exception is UnsupportedError || exception is UnimplementedError) {
      return AssetsManager.forbiddenError;
    }

    if (exception is NoSuchMethodError) {
      return AssetsManager.notFoundError;
    }

    if (exception is ConcurrentModificationError) {
      return AssetsManager.unexpectedError;
    }
    if (exception is InternetException) {
      return AssetsManager.noInternetConnection;
    }

    // Default error icon
    return AssetsManager.errorIcon;
  }
}
