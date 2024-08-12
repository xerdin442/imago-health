import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/models/chat%20model/chat_model.dart';
import 'package:test/view%20model/symptom%20view%20model/symptom_chat_history_provider.dart';
import 'package:test/view%20model/symptom%20view%20model/symptom_chat_id_provider.dart';

class SymptomChatService {
  final SymptomChatIdProvider chatIdProvider;
  final SymptomChatHistoryProvider chatHistoryProvider;

  SymptomChatService(this.chatIdProvider, this.chatHistoryProvider);

  Future<void> askAssitant(
      Map<String, dynamic> body, BuildContext context) async {
    final chatId = chatIdProvider.symptomChatId;
    String url =
        "https://imago-health.onrender.com/api/ask-health-assistant/$chatId";

    // Retrieve the session cookie
    String? sessionCookie = await _retrieveSessionCookie();
    if (sessionCookie == null) {
      print("Session cookie is not available.");
      return;
    }

    try {
      print("send function called");
      
      Dio dio = Dio();
      dio.options.headers = {
        'Content-Type': 'application/json',
        'Cookie': sessionCookie,
      };

      final response = await dio.post(
        url,
        data: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print("Message sent to AI successfully");
        final Map<String, dynamic> responseData = response.data;
        String chatResponse =
            responseData['response'].replaceAll(RegExp(r'[*_#~`>|-]'), '');
        print("AI response: $chatResponse");

        // Create a ChatMessage for the AI response
        final aiMessage = ChatMessage(
          content: chatResponse,
          sender: Sender.ai,
        );

        // Update the chat history in the provider
        chatHistoryProvider.addSymptomsMessage(aiMessage);
      } else {
        print("Status code: ${response.statusCode}");
        print("Response data: ${response.data}");
        final aiMessage = ChatMessage(
          content: "Couldn't generate response, check your internet connection and try again",
          sender: Sender.ai,
        );
        chatHistoryProvider.addSymptomsMessage(aiMessage);
      }
    } catch (e) {
      print("An error occurred: $e");
      final aiMessage = ChatMessage(
        content: "Couldn't generate response, check your internet connection and try again",
        sender: Sender.ai,
      );
      chatHistoryProvider.addSymptomsMessage(aiMessage);
    }
  }

  Future<String?> _retrieveSessionCookie() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('sessionCookie');
  }
}
