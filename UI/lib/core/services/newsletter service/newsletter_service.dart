import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/models/newsletter%20model/newsletter_model.dart';
import 'package:test/view%20model/newsletter%20view%20model/newsletter_provider.dart';

class NewsletterService {
  Future<void> fetchNewsletters(BuildContext context) async {
    String url = 'https://imago-health.onrender.com/api/newsletters';

    Dio dio = Dio();
    String? sessionCookie = await _retrieveSessionCookie();
    if (sessionCookie == null) {
      print("Session cookie is not available.");
      return;
    }

    dio.options.headers = {
      "Cookie": sessionCookie,
    };

    try {
      print("Fetching newsletters...");

      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.toString());
        List newslettersData = data['newsletters'];

        List<Newsletter> newsletters = newslettersData.map((newsletterData) {
          String id = newsletterData['_id'];
          String content = newsletterData['content'];
          String title = extractTitle(content);
          String body = extractBody(content);
          return Newsletter(id: id, title: title, body: body);
        }).toList();

        context.read<NewsletterProvider>().setNewsletters(newsletters);
      } else {
        print("Server returned an error: ${response.statusCode}");
        print("Response data: ${response.data}");
      }
    } catch (e) {
      print("Exception caught: $e");
    }
  }

  Future<String?> _retrieveSessionCookie() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('sessionCookie');
  }

  String extractTitle(String content) {
    List<String> parts = content.split('\n\n');
    for (String part in parts) {
      if (part.startsWith('##')) {
        return part.replaceAll(RegExp(r'[*_#~`>|-]'), '').trim();
      }
    }
    return '';
  }

  String extractBody(String content) {
    List<String> parts = content.split('\n\n');
    bool foundTitle = false;
    String body = '';

    for (String part in parts) {
      if (foundTitle) {
        body += '$part\n\n';
      } else if (part.startsWith('##')) {
        foundTitle = true;
      }
    }

    return body.replaceAll(RegExp(r'[*_#~`>|-]'), '').trim();
  }
}
