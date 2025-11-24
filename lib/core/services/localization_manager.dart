import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';

class LocalizationManager {
  static List<Locale> supportedLocales = const [Locale("ar"), Locale("en")];
  static int currentLocaleIndex = 1;

  static Future<void> changeLanguage(String languageCode) async {
    if (languageCode == "en") {
      currentLocaleIndex = 1;
    } else {
      currentLocaleIndex = 0;
    }
    await S.load(getCurrentLocale());
  }

  static Locale getCurrentLocale() {
    return supportedLocales[currentLocaleIndex];
  }

  // static String getAppTitle() {
  //   return currentLocaleIndex == 0 ? "Ma" : "Tarsheed";
  // }

  // static String getLanguageName() {
  //   return currentLocaleIndex == 0 ? "arabic" : "english";
  // }
}
