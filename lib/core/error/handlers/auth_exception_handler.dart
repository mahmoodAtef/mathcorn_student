import 'package:firebase_auth/firebase_auth.dart';
import 'package:math_corn/core/error/exception_manager.dart';
import 'package:math_corn/core/services/localization_manager.dart';
import 'package:math_corn/core/utils/assets_manager.dart';

class FirebaseAuthExceptionHandler implements ExceptionHandler {
  @override
  String handle(Exception exception) {
    if (exception is FirebaseAuthException) {
      final isArabic =
          LocalizationManager.getCurrentLocale().languageCode == 'ar';

      switch (exception.code) {
        case 'invalid-email':
          return isArabic
              ? 'البريد الإلكتروني غير صالح'
              : 'Invalid email address';

        case 'user-disabled':
          return isArabic
              ? 'تم تعطيل حساب المستخدم'
              : 'User account has been disabled';

        case 'user-not-found':
          return isArabic ? 'المستخدم غير موجود' : 'User not found';

        case 'wrong-password':
          return isArabic ? 'كلمة المرور غير صحيحة' : 'Incorrect password';

        case 'email-already-in-use':
          return isArabic
              ? 'البريد الإلكتروني مستخدم بالفعل'
              : 'Email is already in use';

        case 'operation-not-allowed':
          return isArabic
              ? 'هذه العملية غير مسموح بها'
              : 'This operation is not allowed';

        case 'weak-password':
          return isArabic ? 'كلمة المرور ضعيفة جداً' : 'Password is too weak';

        case 'account-exists-with-different-credential':
          return isArabic
              ? 'يوجد حساب مرتبط ببيانات اعتماد مختلفة'
              : 'Account exists with different credentials';

        case 'invalid-credential':
          return isArabic
              ? 'البريد الإلكتروني أو كلمة المرور غير صحيحة'
              : 'Invalid email or password';

        case 'invalid-verification-code':
          return isArabic ? 'رمز التحقق غير صالح' : 'Invalid verification code';

        case 'invalid-verification-id':
          return isArabic ? 'معرف التحقق غير صالح' : 'Invalid verification ID';

        case 'too-many-requests':
          return isArabic
              ? 'عدد كبير من المحاولات. يرجى المحاولة لاحقاً'
              : 'Too many requests. Please try again later';

        case 'credential-already-in-use':
          return isArabic
              ? 'بيانات الاعتماد مستخدمة بالفعل'
              : 'Credentials are already in use';

        case 'requires-recent-login':
          return isArabic
              ? 'يرجى تسجيل الدخول مجدداً لإكمال العملية'
              : 'Please login again to complete this operation';

        case 'network-request-failed':
          return isArabic
              ? 'فشل الاتصال بالشبكة. تحقق من اتصالك بالإنترنت'
              : 'Network connection failed. Check your internet connection';

        case 'session-cookie-expired':
          return isArabic ? 'انتهت صلاحية الجلسة' : 'Session expired';

        case 'id-token-expired':
          return isArabic ? 'انتهت صلاحية رمز الهوية' : 'ID token expired';

        case 'id-token-revoked':
          return isArabic ? 'تم إلغاء رمز الهوية' : 'ID token revoked';

        case 'invalid-action-code':
          return isArabic ? 'رمز الإجراء غير صالح' : 'Invalid action code';

        case 'expired-action-code':
          return isArabic ? 'انتهت صلاحية رمز الإجراء' : 'Action code expired';

        case 'invalid-continue-uri':
          return isArabic ? 'رابط المتابعة غير صالح' : 'Invalid continue URL';

        case 'missing-continue-uri':
          return isArabic ? 'رابط المتابعة مفقود' : 'Missing continue URL';

        case 'missing-email':
          return isArabic ? 'البريد الإلكتروني مفقود' : 'Email is missing';

        case 'missing-phone-number':
          return isArabic ? 'رقم الهاتف مفقود' : 'Phone number is missing';

        case 'invalid-phone-number':
          return isArabic ? 'رقم الهاتف غير صالح' : 'Invalid phone number';

        case 'quota-exceeded':
          return isArabic ? 'تم تجاوز الحد المسموح' : 'Quota exceeded';

        case 'app-deleted':
          return isArabic ? 'تم حذف التطبيق' : 'App deleted';

        case 'captcha-check-failed':
          return isArabic
              ? 'فشل في التحقق من الكابتشا'
              : 'CAPTCHA verification failed';

        case 'code-expired':
          return isArabic ? 'انتهت صلاحية الرمز' : 'Verification code expired';

        case 'missing-verification-code':
          return isArabic ? 'رمز التحقق مفقود' : 'Verification code is missing';

        case 'missing-verification-id':
          return isArabic ? 'معرف التحقق مفقود' : 'Verification ID is missing';

        default:
          return isArabic
              ? 'حدث خطأ أثناء المصادقة. يرجى المحاولة لاحقاً'
              : 'Authentication error occurred. Please try again later';
      }
    }
    final isArabic =
        LocalizationManager.getCurrentLocale().languageCode == 'ar';
    return isArabic ? 'حدث خطأ غير متوقع' : 'Unexpected error occurred';
  }

  @override
  String getIconPath(Exception exception) {
    if (exception is FirebaseAuthException) {
      switch (exception.code) {
        // Bad Request Errors
        case 'invalid-email':
        case 'invalid-credential':
        case 'invalid-verification-code':
        case 'invalid-verification-id':
        case 'invalid-phone-number':
        case 'invalid-action-code':
        case 'invalid-continue-uri':
        case 'missing-email':
        case 'missing-phone-number':
        case 'missing-continue-uri':
        case 'missing-verification-code':
        case 'missing-verification-id':
          return AssetsManager.badRequestError;

        // Forbidden Errors
        case 'user-disabled':
        case 'operation-not-allowed':
        case 'requires-recent-login':
        case 'app-deleted':
        case 'quota-exceeded':
          return AssetsManager.forbiddenError;

        // Not Found Errors
        case 'user-not-found':
          return AssetsManager.notFoundError;

        // Unauthorized Errors
        case 'wrong-password':
        case 'email-already-in-use':
        case 'account-exists-with-different-credential':
        case 'credential-already-in-use':
        case 'weak-password':
        case 'session-cookie-expired':
        case 'id-token-expired':
        case 'id-token-revoked':
          return AssetsManager.unauthorizedError;

        // Network Connection Errors
        case 'network-request-failed':
          return AssetsManager.noInternetConnection;

        // Server Errors
        case 'too-many-requests':
          return AssetsManager.internalServerError;

        // Expired/Time-related Errors
        case 'expired-action-code':
        case 'code-expired':
          return AssetsManager.unexpectedError;

        // Captcha/Verification Errors
        case 'captcha-check-failed':
          return AssetsManager.errorIcon;

        default:
          return AssetsManager.errorIcon;
      }
    }
    return AssetsManager.unexpectedError;
  }
}
