import 'package:flutter/foundation.dart';
import 'package:test/models/newsletter%20model/newsletter_model.dart';

class NewsletterProvider with ChangeNotifier {
  List<Newsletter> _newsletters = [];

  List<Newsletter> get newsletters => _newsletters;

  void setNewsletters(List<Newsletter> newsletters) {
    _newsletters = newsletters;
    notifyListeners();
  }

  void addNewsletter(Newsletter newsletter) {
    _newsletters.add(newsletter);
    notifyListeners();
  }
}
