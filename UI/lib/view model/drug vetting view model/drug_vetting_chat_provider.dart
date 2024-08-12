import 'package:flutter/material.dart';
import 'package:test/models/chat%20model/chat_model.dart';

class DrugVettingChatProvider with ChangeNotifier {
  List<ChatMessage> _drugVettingChatHistory = [];

  List<ChatMessage> get drugVettingChatHistory => _drugVettingChatHistory;

  void addDrugVettingMessage(ChatMessage message) {
    _drugVettingChatHistory.add(message);
    notifyListeners();
  }

  void clearDrugVettingChatHistory() {
    _drugVettingChatHistory.clear();
    notifyListeners();
  }
}
