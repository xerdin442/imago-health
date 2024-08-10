import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MedicalRecordService {
  MedicalRecordService();

  Future<void> updateRecord(Map<String, dynamic> body) async {
    String url = "https://imago-health.onrender.com/api/records/create-record";
    String? sessionCookie =
        await _retrieveSessionCookie(); // Retrieve the session cookie

    if (sessionCookie == null) {
      print("Session cookie is not available.");
      return;
    }

    try {
      print("process bugun");
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': sessionCookie,
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        print("User record updated successfully!");
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
