import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RegisterServices {
  RegisterServices();

  Future<void> registerUser(Map<String, dynamic> body) async { // Changed Object to Map<String, dynamic>
    String url = "https://imago-health.onrender.com/api/auth/register";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'}, // Set the Content-Type
        body: jsonEncode(body), // Convert body to JSON string
      );

      if (response.statusCode == 200) {
        print("Registration successful!");
        print("Your status code is ${response.statusCode}");
        print(response.body);


         final sessionCookie = response.headers['set-cookie'];
        if (sessionCookie != null) {
          // Save the session cookie
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('sessionCookie', sessionCookie);
        }

        // Save user session
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
      } else {
        print("Your status code is ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (e) {
      print("An error occurred: $e");
    }
  }
}
