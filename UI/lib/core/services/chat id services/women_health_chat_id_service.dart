import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/view%20model/women%20health%20view%20model/women_health_chat_id_provider.dart';

class WomenHealthChatIdService {
  final WomenHealthChatIdProvider chatIdProvider;

  WomenHealthChatIdService(this.chatIdProvider);

  Future<void> getChatId() async {
    String url =
        "https://imago-health.onrender.com/api/launch-assistant?womensHealth=true";
    String? sessionCookie = await _retrieveSessionCookie();

    if (sessionCookie == null) {
      print("Session cookie is not available.");
      return;
    }

    try {
      print("Process started");
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': sessionCookie,
        },
      );

      if (response.statusCode == 200) {
        print("Chat Id generated successfully!");

        // Parse the response body
        final Map<String, dynamic> responseData = json.decode(response.body);
        String? chatId = responseData['chatId'];
        print("Chat Id: $chatId");

        // Set the chatId in the provider
        chatIdProvider.setwomenHealthChatId(chatId);
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
