import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/view%20model/addiction%20view%20model/addition_chat_id_provider.dart';

class AddictionChatIdService {
  final AddictionChatIdProvider chatIdProvider;

  AddictionChatIdService(this.chatIdProvider);

  Future<void> getChatId() async {
    String url =
        "https://imago-health.onrender.com/api/launch-assistant?addiction=true";
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
        chatIdProvider.setadditionChatId(chatId);
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
