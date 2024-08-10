import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/models/chat%20model/chat_model.dart';
import 'package:test/view%20model/non%20binary%20view%20model/non_binary_chat_history_provider.dart';
import 'package:test/view%20model/non%20binary%20view%20model/non_binary_chat_id_provider.dart';

class NonBinaryChatService {
  final NonBinaryChatIdProvider chatIdProvider;
  final NonBinaryChatHistoryProvider chatHistoryProvider;

  NonBinaryChatService(this.chatIdProvider, this.chatHistoryProvider);

  Future<void> askAssitant(
      Map<String, dynamic> body, BuildContext context) async {
    final chatId = chatIdProvider.nonBinaryChatId;
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
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': sessionCookie,
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print("message sent to ai successfully");
        final Map<String, dynamic> responseData = json.decode(response.body);
        String chatResponse = responseData['response'].replaceAll(RegExp(r'[*_#~`>|-]'), '');
        print("AI response: $chatResponse");

        // Create a ChatMessage for the AI response
        final aiMessage = ChatMessage(
          content: chatResponse,
          sender: Sender.ai,
        );

        // Update the chat history in the provider
        chatHistoryProvider.addnonBinarysMessage(aiMessage);
      } else {
        print("Status code: ${response.statusCode}");
        print("Response body: ${response.body}");
              final aiMessage = ChatMessage(
        content:
            "Could generate response, check your internet connection and try again",
        sender: Sender.ai,
      );
      chatHistoryProvider.addnonBinarysMessage(aiMessage);
      }
    } catch (e) {
      print("An error occurred: $e");
            final aiMessage = ChatMessage(
        content:
            "Could generate response, check your internet connection and try again",
        sender: Sender.ai,
      );
      chatHistoryProvider.addnonBinarysMessage(aiMessage);
    }
  }

  Future<String?> _retrieveSessionCookie() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('sessionCookie');
  }
}
