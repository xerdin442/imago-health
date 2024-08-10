import 'package:flutter/material.dart';

class WomenHealthChatIdProvider extends ChangeNotifier {
  String? _womenHealthChatId;

  String? get womenHealthChatId => _womenHealthChatId;

  void setwomenHealthChatId(String? womenHealthChatId) {
    _womenHealthChatId = womenHealthChatId;
    notifyListeners();
  }
}
