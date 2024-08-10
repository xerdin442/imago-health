import 'dart:convert'; // Import for base64 encoding
import 'dart:io'; // Import for working with files
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/models/chat%20model/chat_model.dart';

import '../../../view model/drug vetting view model/drug_vetting_chat_provider.dart';

class UploadImageService {
  Future<void> uploadImage(BuildContext context, XFile image) async {
    String url = 'https://imago-health.onrender.com/api/drug-vetting';

    File imageFile = File(image.path);
    List<int> imageBytes = await imageFile.readAsBytes();

    String base64Image = base64Encode(imageBytes);

    String? sessionCookie = await _retrieveSessionCookie();
    if (sessionCookie == null) {
      print("Session cookie is not available.");
      return;
    }

    Dio dio = Dio();
    dio.options.headers = {
      "Cookie": sessionCookie,
      "Content-Type": "application/json",
      "User-Agent": "PostmanRuntime/7.40.0",
      "Accept": "*/*",
      "Accept-Encoding": "gzip, deflate, br",
      "Connection": "keep-alive"
    };

    Map<String, dynamic> data = {
      "drugImage": base64Image,
    };

    try {
      print("Process began");
      Response response = await dio.post(url, data: jsonEncode(data));
      if (response.statusCode == 200) {
        print("Image uploaded successfully");
        // print(response.data);

        var responseDataMap = jsonDecode(response.toString());
        String chatResponse = responseDataMap['description'];

        chatResponse = chatResponse.replaceAll(RegExp(r'[*_#~`>|-]'), '');
        print(chatResponse);

        final aiMessage = ChatMessage(
          content: chatResponse,
          sender: Sender.ai,
        );

        final chatHistoryProvider =
            Provider.of<DrugVettingChatProvider>(context, listen: false);
        chatHistoryProvider.addDrugVettingMessage(aiMessage);
      } else {
        print("An Error occurred: ${response.statusCode}");
      }
    } on DioException catch (e) {
    if (e.type == DioExceptionType.connectionError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(child: Text("Network error occurred. Please try again.")),
          ),
        );
    } else {
             ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(child: Text("An error occurred, try uploading the image again")),
          ),
        );
    }
  }
    catch (e) {
      print("Exception caught: $e");
    }
  }

  Future<String?> _retrieveSessionCookie() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('sessionCookie');
  }
}
