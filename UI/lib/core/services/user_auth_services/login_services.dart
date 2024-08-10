import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginServices {

  LoginServices();

  Future<void> loginUser(Map<String, dynamic> body) async { 
    String url = "https://imago-health.onrender.com/api/auth/login";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print("Login successful!");
        print("Your status code is ${response.statusCode}");
        print(response.body);

        // Extract the session cookie from the response headers
        final sessionCookie = response.headers['set-cookie'];
        if (sessionCookie != null) {
          // Save the session cookie
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('sessionCookie', sessionCookie);
        }

        // Optionally save login status
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        
        return;
      } else {
        print("Your status code is ${response.statusCode}");
        print(response.body);
      }
    } catch (e) {
      print("An error occurred: $e");
    }
  }
}
