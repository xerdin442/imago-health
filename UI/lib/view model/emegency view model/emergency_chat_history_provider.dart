import 'package:flutter/material.dart';
import 'package:test/models/chat%20model/chat_model.dart';

class EmergencyChatHistoryProvider with ChangeNotifier {
  List<ChatMessage> _emergencyChatHistory = [];

  List<ChatMessage> get emergencyChatHistory => _emergencyChatHistory;

  void addEmergencyMessage(ChatMessage message) {
    _emergencyChatHistory.add(message);
    notifyListeners();
  }

  void setEmergencyChatHistory(List<ChatMessage> emergencyChatHistory) {
    _emergencyChatHistory = emergencyChatHistory;
    notifyListeners();
  }
}
