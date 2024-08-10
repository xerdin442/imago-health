import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/models/chat%20model/chat_model.dart';
import 'package:test/view%20model/emegency%20view%20model/emergency_chat_history_provider.dart';
import 'package:test/view%20model/emegency%20view%20model/emergency_chat_id_provider.dart';

class EmergencyCompleteChatHistory {
  Future<String?> _retrieveSessionCookie() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('sessionCookie');
  }

  Future<void> getChatHistory(BuildContext context) async {
    final chatIdProvider = Provider.of<EmergencyChatIdProvider>(context, listen: false);
    final chatId = chatIdProvider.emergencyChatId;
    String url = "https://imago-health.onrender.com/api/chats/$chatId";

    final sessionCookie = await _retrieveSessionCookie();
    if (sessionCookie == null) {
      print("No session cookie found. User might not be logged in.");
      return;
    }

    try {
      print("Get chat history function called");
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': sessionCookie,
        },
      );

      if (response.statusCode == 200) {
        print("Chat history retrieved successfully");
        // print(response.body);
        // Parse the response body
        final List<dynamic> responseData = json.decode(response.body);

        // Convert the response data to a list of ChatMessage objects
        List<ChatMessage> chatHistory = responseData
            .map((data) => ChatMessage(
                content: data,
                sender: data == responseData.first ? Sender.user : Sender.ai))
            .toList();

        // Update the chat history in the provider
        final chatHistoryProvider =
            Provider.of<EmergencyChatHistoryProvider>(context, listen: false);
        chatHistoryProvider.setEmergencyChatHistory(chatHistory);
      } else {
        print("Status code: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (e) {
      print("An error occurred: $e");
    }
  }
}
