import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MedicalRecordService {
  MedicalRecordService();

  Future<void> updateRecord(Map<String, dynamic> body) async {
    String url = "https://imago-health.onrender.com/api/records/create-record";
    String? sessionCookie = await _retrieveSessionCookie();

    if (sessionCookie == null) {
      print("Session cookie is not available.");
      return;
    }

    try {
      print("Process begun");
      Dio dio = Dio();

      final response = await dio.post(
        url,
        data: json.encode(body),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Cookie': sessionCookie,
          },
          followRedirects: false,
        ),
      );

      if (response.statusCode == 200) {
        print("User record updated successfully!");
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
