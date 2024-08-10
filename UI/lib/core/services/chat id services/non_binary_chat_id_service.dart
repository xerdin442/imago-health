import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/view%20model/non%20binary%20view%20model/non_binary_chat_id_provider.dart';

class NonBinaryChatIdService {
  final NonBinaryChatIdProvider chatIdProvider;

  NonBinaryChatIdService(this.chatIdProvider);

  Future<void> getChatId() async {
    String url =
        "https://imago-health.onrender.com/api/launch-assistant?nonBinary=true";
    String? sessionCookie =
        await _retrieveSessionCookie(); // Retrieve the session cookie

    if (sessionCookie == null) {
      print("Session cookie is not available.");
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': sessionCookie, // Include the session cookie
        },
      );

      if (response.statusCode == 200) {
        print("Chat Id generated successfully!");

        // Parse the response body
        final Map<String, dynamic> responseData = json.decode(response.body);
        String? chatId = responseData['chatId'];
        print("Chat Id: $chatId");

        // Set the chatId in the provider
        chatIdProvider.setnonBinaryChatId(chatId);
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


