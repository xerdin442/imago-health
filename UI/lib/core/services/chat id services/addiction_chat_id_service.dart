import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/view%20model/addiction%20view%20model/addition_chat_id_provider.dart';

class AddictionChatIdService {
  final AddictionChatIdProvider chatIdProvider;

  AddictionChatIdService(this.chatIdProvider);

  Future<void> getChatId() async {
    String url =
        "https://imago-health.onrender.com/api/launch-assistant?addiction=true";
    String? sessionCookie = await _retrieveSessionCookie();

    if (sessionCookie == null) {
      print("Session cookie is not available.");
      return;
    }

    try {
      Dio dio = Dio();

      final response = await dio.post(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Cookie': sessionCookie,
          },
          followRedirects: false,
        ),
      );

      if (response.statusCode == 200) {
        print("Chat Id generated successfully!");

        // Parse the response data
        final Map<String, dynamic> responseData = response.data;
        String? chatId = responseData['chatId'];
        print("Chat Id: $chatId");

        // Set the chatId in the provider
        chatIdProvider.setadditionChatId(chatId);
      } else {
        print("Status code: ${response.statusCode}");
        print("Response body: ${response.data}");
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
