import 'package:firebase_core/firebase_core.dart';
import 'package:math_corn/core/error/exception_manager.dart';
import 'package:math_corn/core/services/localization_manager.dart';
import 'package:math_corn/core/utils/assets_manager.dart';

class FirebaseExceptionHandler implements ExceptionHandler {
  @override
  String handle(Exception exception) {
    if (exception is! FirebaseException) {
      final isArabic =
          LocalizationManager.getCurrentLocale().languageCode == 'ar';
      return isArabic ? "خطأ غير معروف" : "Unknown error";
    }

    final isArabic =
        LocalizationManager.getCurrentLocale().languageCode == 'ar';

    switch (exception.code) {
      case 'invalid-argument':
        return isArabic ? "معطى غير صالح" : "Invalid argument provided";

      case 'not-found':
        return isArabic
            ? "المورد المطلوب غير موجود"
            : "Requested resource not found";

      case 'already-exists':
        return isArabic ? "المورد موجود بالفعل" : "Resource already exists";

      case 'permission-denied':
        return isArabic ? "تم رفض الإذن" : "Permission denied";

      case 'unauthenticated':
        return isArabic
            ? "المستخدم غير مصادق عليه"
            : "User is not authenticated";

      case 'resource-exhausted':
        return isArabic ? "تم استنفاد الموارد" : "Resource exhausted";

      case 'failed-precondition':
        return isArabic ? "فشل في الشرط المسبق" : "Failed precondition";

      case 'aborted':
        return isArabic ? "تم إلغاء العملية" : "Operation aborted";

      case 'out-of-range':
        return isArabic ? "القيمة خارج النطاق" : "Value out of range";

      case 'unimplemented':
        return isArabic ? "العملية غير مطبقة" : "Operation not implemented";

      case 'internal':
        return isArabic ? "حدث خطأ داخلي" : "Internal error occurred";

      case 'unavailable':
        return isArabic ? "الخدمة غير متاحة" : "Service unavailable";

      case 'data-loss':
        return isArabic ? "حدث فقدان في البيانات" : "Data loss occurred";

      case 'cancelled':
        return isArabic ? "تم إلغاء العملية" : "Operation cancelled";

      case 'deadline-exceeded':
        return isArabic ? "تم تجاوز المهلة الزمنية" : "Deadline exceeded";

      case 'unknown':
        return isArabic ? "حدث خطأ غير معروف" : "Unknown error occurred";

      case 'network-error':
        return isArabic ? "خطأ في الشبكة" : "Network error";

      case 'timeout':
        return isArabic ? "انتهت مهلة الاتصال" : "Connection timeout";

      case 'storage-error':
        return isArabic ? "خطأ في التخزين" : "Storage error";

      case 'database-error':
        return isArabic ? "خطأ في قاعدة البيانات" : "Database error";

      case 'firestore-error':
        return isArabic ? "خطأ في Firestore" : "Firestore error";

      case 'functions-error':
        return isArabic ? "خطأ في Cloud Functions" : "Cloud Functions error";

      case 'messaging-error':
        return isArabic ? "خطأ في الرسائل" : "Messaging error";

      case 'analytics-error':
        return isArabic ? "خطأ في التحليلات" : "Analytics error";

      case 'crashlytics-error':
        return isArabic ? "خطأ في Crashlytics" : "Crashlytics error";

      case 'config-error':
        return isArabic ? "خطأ في التكوين" : "Configuration error";

      case 'performance-error':
        return isArabic ? "خطأ في الأداء" : "Performance monitoring error";

      case 'app-check-error':
        return isArabic ? "خطأ في فحص التطبيق" : "App Check error";

      case 'installations-error':
        return isArabic ? "خطأ في التثبيتات" : "Installations error";

      case 'dynamic-links-error':
        return isArabic ? "خطأ في الروابط الديناميكية" : "Dynamic Links error";

      case 'ml-error':
        return isArabic ? "خطأ في التعلم الآلي" : "Machine Learning error";

      default:
        final errorMessage =
            exception.message ?? (isArabic ? "خطأ غير معروف" : "Unknown error");
        return isArabic
            ? "خطأ Firebase: $errorMessage"
            : "Firebase error: $errorMessage";
    }
  }

  @override
  String getIconPath(Exception exception) {
    if (exception is! FirebaseException) {
      return AssetsManager.unexpectedError;
    }

    switch (exception.code) {
      // Permission/Authentication Errors
      case 'permission-denied':
      case 'unauthenticated':
        return AssetsManager.unauthorizedError;

      // Not Found Errors
      case 'not-found':
        return AssetsManager.notFoundError;

      // Bad Request/Invalid Argument Errors
      case 'invalid-argument':
      case 'out-of-range':
      case 'failed-precondition':
        return AssetsManager.badRequestError;

      // Network/Connection Errors
      case 'network-error':
      case 'timeout':
      case 'unavailable':
        return AssetsManager.noInternetConnection;

      // Server/Internal Errors
      case 'internal':
      case 'resource-exhausted':
      case 'deadline-exceeded':
      case 'database-error':
      case 'firestore-error':
      case 'functions-error':
        return AssetsManager.internalServerError;

      // Data Related Errors
      case 'data-loss':
      case 'storage-error':
        return AssetsManager.noDataFound;

      // Operation Errors
      case 'cancelled':
      case 'aborted':
      case 'unimplemented':
      case 'already-exists':
        return AssetsManager.forbiddenError;

      // Service Specific Errors
      case 'messaging-error':
      case 'analytics-error':
      case 'crashlytics-error':
      case 'config-error':
      case 'performance-error':
      case 'app-check-error':
      case 'installations-error':
      case 'dynamic-links-error':
      case 'ml-error':
        return AssetsManager.errorIcon;

      // Unknown/Default Errors
      case 'unknown':
      default:
        return AssetsManager.errorIcon;
    }
  }
}
