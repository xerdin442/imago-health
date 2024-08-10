import 'package:flutter/material.dart';

class AddictionChatIdProvider extends ChangeNotifier {
  String? _additionChatId;

  String? get additionChatId => _additionChatId;

  void setadditionChatId(String? additionChatId) {
    _additionChatId = additionChatId;
    notifyListeners();
  }
}
