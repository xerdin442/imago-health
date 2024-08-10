import 'package:flutter/material.dart';

class LocalizationProvider with ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (!L10n.all.contains(locale)) return;

    _locale = locale;
    notifyListeners();
  }

  void clearLocale() {
    _locale = const Locale('en');
    notifyListeners();
  }
}

class L10n {
  static final all = [
    const Locale('en'),
    const Locale('fr'),
    const Locale('ar'),
    const Locale('es'),
    const Locale('pt'),
    const Locale('hi'),
  ];

  static String getFlag(String code) {
    switch (code) {
      case 'en':
        return 'English 🇺🇸';
      case 'fr':
        return 'French 🇫🇷';
      case 'ar':
        return 'Arabic 🇸🇦';
      case 'es':
        return 'Spanish 🇪🇸';
      case 'pt':
        return 'Portugueese 🇵🇹';
      case 'hi':
        return 'Hindi 🇮🇳';
      default:
        return 'English 🇺🇸';
    }
  }
}
