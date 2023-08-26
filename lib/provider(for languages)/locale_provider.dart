import 'package:flutter/material.dart';

class LocaleProvider extends ChangeNotifier {
  late Locale _locale;

  LocaleProvider() {
    // Set an initial value for the _locale variable
    _locale = const Locale('en'); // Set the default locale to English ('en')
  }

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }
}