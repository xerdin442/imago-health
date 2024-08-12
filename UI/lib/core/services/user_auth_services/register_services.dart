import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterServices {
  RegisterServices();

  Future<void> registerUser(Map<String, dynamic> body) async { 
    String url = "https://imago-health.onrender.com/api/auth/register";

    try {
      Dio dio = Dio();

      final response = await dio.post(
        url,
        data: jsonEncode(body),
        options: Options(
          headers: {'Content-Type': 'application/json'}, // Set the Content-Type
          followRedirects: false,
        ),
      );

      if (response.statusCode == 200) {
        print("Registration successful!");
        print("Your status code is ${response.statusCode}");
        print(response.data);

        // Extract the session cookie from the response headers
        final sessionCookie = response.headers['set-cookie']?.first;
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
        print("Response body: ${response.data}");
      }
    } catch (e) {
      print("An error occurred: $e");
    }
  }
}
