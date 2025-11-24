import 'package:package_info_plus/package_info_plus.dart';

class ConstantsManager {
  static const String appName = 'MathCorn';
  static const String whatsAppNumber = '1234567890';
  static const String email = 'support@alsunnah.com';
  static const String emailUrl = 'mailto:$email';
  static const String phoneNumber = 'tel:+1234567890';
  static const String privacyPolicyUrl = 'https://alsunnah.com/privacy-policy';
  static const String whatsAppUrl = 'https://wa.me/$whatsAppNumber?text=Hello';
  static PackageInfo? packageInfo;

  // user grade
  static String? userGrade;
}
