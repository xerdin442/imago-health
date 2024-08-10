import 'package:flutter/material.dart';
import 'package:test/models/chat%20model/chat_model.dart';

class AddictionChatHistoryProvider with ChangeNotifier {
  List<ChatMessage> _additionChatHistory = [
    ChatMessage(
          content: "Welcome to IMAGO, Your Path to Recovery! Hi there! I'm your AI companion on IMAGO, a confidential space to help you overcome addiction. Whether you struggle with alcohol, tobacco, pornography, gambling, or hard drugs, IMAGO is here to guide and support you on your journey to recovery. Think of me as your friendly coach, here to listen without judgement and provide you with the tools and information you need to succeed. Here's what you can expect with IMAGO: Personalized Guidance: Tell me about your specific addiction, and I'll tailor our sessions to your needs and goals. Evidence-Based Techniques: Learn practical tools and strategies to manage cravings, develop healthy coping mechanisms, and prevent relapse. Daily Support: You can check in regularly, let's monitor your progress, identify challenges, and offer encouragement. Building Resilience: We'll work together to build your inner strength and confidence to overcome addiction. Remember, recovery is a journey, and there will be ups and downs. But you don't have to go it alone. With IMAGO by your side, you have the power to break free from addiction and build a healthier, happier life. Let's get started! Tell me a little about yourself and what you'd like to achieve.",
          sender: Sender.ai,
        )
  ];

  List<ChatMessage> get additionChatHistory => _additionChatHistory;

  void addAdditionsMessage(ChatMessage message) {
    _additionChatHistory.add(message);
    notifyListeners();
  }

  void setAdditionChatHistory(List<ChatMessage> additionChatHistory) {
    _additionChatHistory = additionChatHistory;
    notifyListeners();
  }
}
