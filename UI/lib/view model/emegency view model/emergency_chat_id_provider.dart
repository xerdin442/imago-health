import 'package:flutter/material.dart';

class EmergencyChatIdProvider extends ChangeNotifier {
  String? _emergencyChatId;

  String? get emergencyChatId => _emergencyChatId;

  void setEmergencyChatId(String? emergencyChatId) {
    _emergencyChatId = emergencyChatId;
    notifyListeners();
  }
}
