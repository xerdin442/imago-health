import 'package:flutter/material.dart';
import 'package:test/models/chat%20model/chat_model.dart';

class NonBinaryChatHistoryProvider with ChangeNotifier {
  List<ChatMessage> _nonBinaryChatHistory = [
    ChatMessage(
          content: "Hi there! I'm your AI companion on IMAGO, a safe space designed to explore and celebrate gender identity. What would you like to talk about today?  Maybe you just want to vent, or maybe you have a specific question.  Whatever it is, I'm here to listen. For those new to the concept, gender identity goes beyond the traditional categories of male and female. It's a personal sense of being a man, woman, neither, both, or somewhere in between. And IMAGO is here to help you navigate this journey of self-discovery, free from judgment. Traditionally, people have talked about gender like there are only two options, boys and girls. But guess what? It's actually more!  Some people feel completely like a boy, some completely like a girl, and others feel like a mix of both, or maybe neither! These amazing folks are called non-binary sexes. Being gay is simply who someone is, just like having brown eyes or curly hair. It's not a choice, and it doesn't affect someone's ability to be a good friend, family member, or neighbor. And just like you wouldn't want someone to judge you for something you can't control or for the colour of your skin, wouldn't it be amazing to create a world where everyone feels safe to be themselves? Sometimes, a little empathy can go a long way. \nHere are some things we can explore together: What does it mean to be non-binary?:  We can break it down step-by-step and see if it resonates with you. \nAm I non-binary? How can I know?:  There's no single answer, but we can explore some signs and how people figure things out. And if you a non-binary sex, congratulations! Here ways I can make your experience even more amazing: Be You, Safely: This is a confidential space where you can express yourself freely without judgment.  Vent about your frustrations, celebrate your wins, or just chat – it's all up to you. Get Support: Feeling stressed or alone? We can talk about ways to cope with the challenges of living in a homophobic society. Learn More:  Have questions about being gay or the LGBTQ+ community? I can give you accurate, up-to-date information. Find Resources:  If it's safe in your area, I can connect you with online resources for LGBTQ+ people in Africa or Asia, like legal aid or support groups. I am here for you, whenever you need me, 24/7. So, tell me friend, what would you like to chat about today?  Let's learn together!",
          sender: Sender.ai,
        ),
  ];

  List<ChatMessage> get nonBinaryChatHistory => _nonBinaryChatHistory;

  void addnonBinarysMessage(ChatMessage message) {
    _nonBinaryChatHistory.add(message);
    notifyListeners();
  }

  void setnonBinaryChatHistory(List<ChatMessage> nonBinaryChatHistory) {
    _nonBinaryChatHistory = nonBinaryChatHistory;
    notifyListeners();
  }
}
