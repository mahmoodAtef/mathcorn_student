import 'package:flutter/cupertino.dart';

extension TextDirectionExtension on String {
  TextDirection get getDirection {
    final arabicRegex = RegExp(r'[\u0600-\u06FF]');
    for (var rune in runes) {
      final char = String.fromCharCode(rune);
      if (RegExp(r'[A-Za-z]').hasMatch(char)) return TextDirection.ltr;
      if (arabicRegex.hasMatch(char)) return TextDirection.rtl;
    }
    return TextDirection.ltr; // default لو النص كله رموز/أرقام
  }
}
