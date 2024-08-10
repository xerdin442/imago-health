import 'package:flutter/material.dart';

class SymptomChatIdProvider extends ChangeNotifier {
  String? _symptomChatId;

  String? get symptomChatId => _symptomChatId;

  void setSymptomChatId(String? symptomChatId) {
    _symptomChatId = symptomChatId;
    notifyListeners();
  }
}
