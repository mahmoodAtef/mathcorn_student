import 'package:math_corn/generated/l10n.dart';
import 'package:math_corn/modules/main/data/models/grade.dart';

class InputValidator {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'البريد الإلكتروني مطلوب';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'البريد الإلكتروني غير صحيح';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'كلمة المرور مطلوبة';
    }
    if (value.length < 8) {
      return 'كلمة المرور يجب أن تكون 8 أحرف على الأقل';
    }
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
      return 'كلمة المرور يجب أن تحتوي على حرف كبير وصغير ورقم';
    }
    return null;
  }

  static String? validatePasswordForLogin(String? value) {
    if (value == null || value.isEmpty) {
      return 'كلمة المرور مطلوبة';
    }
    if (value.length < 6) {
      return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'الاسم مطلوب';
    }
    if (value.length < 2) {
      return 'الاسم يجب أن يكون أكثر من حرفين';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'رقم الهاتف مطلوب';
    }
    if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(value)) {
      return 'رقم الهاتف غير صحيح';
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'تأكيد كلمة المرور مطلوب';
    }
    if (value != password) {
      return 'كلمة المرور غير متطابقة';
    }
    return null;
  }

  // إضافة فانكشنز جديدة للـ validation المطلوب في الشاشات

  static String? validateGrade(int? value) {
    if (value == null) {
      return 'الصف الدراسي مطلوب';
    }
    if (value < 1 || value > 12) {
      return 'الصف الدراسي غير صحيح';
    }
    return null;
  }

  static String? validateStudentPhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'رقم هاتف الطالب مطلوب';
    }
    if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(value)) {
      return 'رقم هاتف الطالب غير صحيح';
    }
    return null;
  }

  static String? validateParentPhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'رقم هاتف ولي الأمر مطلوب';
    }
    if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(value)) {
      return 'رقم هاتف ولي الأمر غير صحيح';
    }
    return null;
  }

  // فانكشن عامة للـ validation مع localization
  static String? validateEmailWithL10n(String? value, dynamic l10n) {
    if (value == null || value.isEmpty) {
      return l10n.emailRequired;
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return l10n.invalidEmail;
    }
    return null;
  }

  static String? validatePasswordWithL10n(String? value, dynamic l10n) {
    if (value == null || value.isEmpty) {
      return l10n.passwordRequired;
    }
    if (value.length < 8) {
      return l10n.passwordTooShort ??
          'كلمة المرور يجب أن تكون 8 أحرف على الأقل';
    }
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
      return l10n.passwordComplexity ??
          'كلمة المرور يجب أن تحتوي على حرف كبير وصغير ورقم';
    }
    return null;
  }

  static String? validatePasswordForLoginWithL10n(String? value, dynamic l10n) {
    if (value == null || value.isEmpty) {
      return l10n.passwordRequired;
    }
    if (value.length < 6) {
      return l10n.passwordTooShort;
    }
    return null;
  }

  static String? validateNameWithL10n(String? value, dynamic l10n) {
    if (value == null || value.isEmpty) {
      return l10n.nameRequired;
    }
    if (value.length < 2) {
      return l10n.nameTooShort ?? 'الاسم يجب أن يكون أكثر من حرفين';
    }
    return null;
  }

  static String? validateConfirmPasswordWithL10n(
    String? value,
    String password,
    dynamic l10n,
  ) {
    if (value == null || value.isEmpty) {
      return l10n.confirmPasswordRequired;
    }
    if (value != password) {
      return l10n.passwordsDoNotMatch;
    }
    return null;
  }

  static String? validateGradeWithL10n(int? value, dynamic l10n) {
    if (value == null) {
      return l10n.gradeRequired;
    }
    if (value < 1 || value > 12) {
      return l10n.invalidGrade ?? 'الصف الدراسي غير صحيح';
    }
    return null;
  }

  static String? validateStudentPhoneWithL10n(String? value, dynamic l10n) {
    if (value == null || value.isEmpty) {
      return l10n.studentPhoneRequired;
    }
    if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(value)) {
      return l10n.invalidPhone ?? 'رقم الهاتف غير صحيح';
    }
    return null;
  }

  static String? validateParentPhoneWithL10n(String? value, dynamic l10n) {
    if (value == null || value.isEmpty) {
      return l10n.parentPhoneRequired;
    }
    if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(value)) {
      return l10n.invalidPhone ?? 'رقم الهاتف غير صحيح';
    }
    return null;
  }

  static String? validateGradeIdWithL10n(String? value, S l10n) {
    if (value == null || value.isEmpty) {
      return l10n.pleaseSelectYourGrade;
    }

    if (GradeData.getGradeById(value) == null) {
      return l10n.invalidGradeSelected;
    }
    return null;
  }
}
