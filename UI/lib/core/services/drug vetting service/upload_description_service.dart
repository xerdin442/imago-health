import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/models/chat%20model/chat_model.dart';
import 'package:test/view%20model/drug%20vetting%20view%20model/drug_vetting_chat_provider.dart';

class UploadDescriptionService {

  Future<void> uploadDescription(
      Map<String, dynamic> body, BuildContext context) async {
    String url =
        "https://imago-health.onrender.com/api/drug-vetting";

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
        String chatResponse = responseData['response'];
        print("AI response: $chatResponse");

      final chatHistoryProvider =
          Provider.of<DrugVettingChatProvider>(context, listen: false);

        // Create a ChatMessage for the AI response
        final aiMessage = ChatMessage(
          content: chatResponse,
          sender: Sender.ai,
        );

        // Update the chat history in the provider
        chatHistoryProvider.addDrugVettingMessage(aiMessage);
      } else {
        print("Status code: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (e) {
      print("An error occurred: $e");
    }
  }

  Future<String?> _retrieveSessionCookie() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('sessionCookie');
  }
}
