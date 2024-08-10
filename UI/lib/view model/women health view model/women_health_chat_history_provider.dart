import 'package:flutter/material.dart';
import 'package:test/models/chat%20model/chat_model.dart';

class WomenHealthChatHistoryProvider with ChangeNotifier {
  List<ChatMessage> _womenHealthChatHistory = [
    ChatMessage(
          content: "Welcome to IMAGO, Your Private Health Guide \nThis is your safe space.  You can ask me anything, about your sexual and reproductive health. Our conversation is completely private and No question is too embarrassing nor out of place. \nI am here to listen without judgment and give you clear, accurate information to guide you. \nHere are some examples of questions you can ask me: Menstruation and Period: What are normal periods like? What are the causes of irregular periods? Can I get pregnant on my period? Is it normal to have cramps during my period? What are healthy period hygiene practices? \nSexual Health: \nWhat is safe sex? Is it normal to experience pain during sex? What are different types of contraception? How effective are different birth control methods? How do I prevent getting pregnant after unprotected sex? How do I use condoms properly? What are sexually transmitted infections (STIs)? What are the symptoms of common STIs? Reproductive Health: What is the menstrual cycle? How can I track my ovulation? What are the signs of pregnancy? What are healthy pregnancy practices? What are the different stages of pregnancy? What are the risks of unsafe abortions? Body Image and Concerns: What is a healthy body image, What are normal changes during puberty? What are the causes of vaginal discharge? Why is my vaginal discharge whitish or dark, thick or smelly? What are healthy practices for vaginal health? Remember, these are just examples, so don't hesitate to ask anything specific to your situation, no matter how personal. We believe every woman deserves access to accurate health information and IMAGO is here for you, every step of the way. So relax, and let's explore your questions together!",
          sender: Sender.ai,
        ),
  ];

  List<ChatMessage> get womenHealthChatHistory => _womenHealthChatHistory;

  void addwomenHealthsMessage(ChatMessage message) {
    _womenHealthChatHistory.add(message);
    notifyListeners();
  }

  void setwomenHealthChatHistory(List<ChatMessage> womenHealthChatHistory) {
    _womenHealthChatHistory = womenHealthChatHistory;
    notifyListeners();
  }
}
