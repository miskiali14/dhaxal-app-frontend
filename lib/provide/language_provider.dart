import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LanguageProvider extends ChangeNotifier {
  String _currentLanguage = 'en';

  final Map<String, Map<String, String>> _localizedValues = {};

  String get currentLanguage => _currentLanguage;

  LanguageProvider() {
    _loadLocalizedValues();
  }

  void _loadLocalizedValues() async {
    for (String locale in ['en', 'so']) {
      String jsonString =
          await rootBundle.loadString('assets/i18n/$locale.json');
      Map<String, dynamic> jsonMap = json.decode(jsonString);
      _localizedValues[locale] = jsonMap.map((key, value) {
        return MapEntry(key, value.toString());
      });
    }
    notifyListeners();
  }

  void changeLanguage(String language) {
    _currentLanguage = language;
    notifyListeners();
  }

  String getText(String key) {
    return _localizedValues[_currentLanguage]?[key] ?? key;
  }
}
