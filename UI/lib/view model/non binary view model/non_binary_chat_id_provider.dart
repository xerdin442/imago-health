import 'package:flutter/material.dart';

class NonBinaryChatIdProvider extends ChangeNotifier {
  String? _nonBinaryChatId;

  String? get nonBinaryChatId => _nonBinaryChatId;

  void setnonBinaryChatId(String? nonBinaryChatId) {
    _nonBinaryChatId = nonBinaryChatId;
    notifyListeners();
  }
}
