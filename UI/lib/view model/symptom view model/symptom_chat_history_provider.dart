import 'package:flutter/material.dart';
import 'package:test/models/chat%20model/chat_model.dart';

class SymptomChatHistoryProvider with ChangeNotifier {
  List<ChatMessage> _symptomChatHistory = [
    ChatMessage(
      content:
          "Hello, welcome to IMAGO. I can help you understand your symptoms better. Tell me the symptoms you are currently experiencing and IMAGO will list the likely illnesses that may be the cause. For example; I am experiencing Headache, Fever, Pain behind my eye sockets, vomiting, e.t.c. Please Note: Symptom checking is only a medical triage and you may need to seek a medical professional for accurate diagnosis and treatment.",
      sender: Sender.ai,
    ),
  ];

  List<ChatMessage> get symptomChatHistory => _symptomChatHistory;

  void addSymptomsMessage(ChatMessage message) {
    _symptomChatHistory.add(message);
    notifyListeners();
  }

  void clearSymptomChatHistory() {
    _symptomChatHistory.clear();
    notifyListeners();
  }

  void setSymptomChatHistory(List<ChatMessage> symptomChatHistory) {
    _symptomChatHistory = symptomChatHistory;
    notifyListeners();
  }
}
