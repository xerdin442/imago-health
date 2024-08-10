import 'package:flutter/material.dart';
import 'package:test/core/services/newsletter%20service/newsletter_service.dart';
import 'package:test/views/home/homepage_screen.dart';
import 'package:test/views/newsletter/newsletter_screen.dart';
import 'package:test/widgets/navigation/bottom_navbar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  void _handleTabSelection(int index) {
    switch (index) {
      case 0:
        break;
      case 1:
        NewsletterService().fetchNewsletters(context);
        break;
      case 2:
        break;
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            IndexedStack(
              index: _selectedIndex,
              children: const [
                HomepageScreen(),
                NewsletterScreen(),
                Center(
                  child: Text("Settings page coming soon"),
                )
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: CustomFloatingNavBar(
                selectedIndex: _selectedIndex,
                onItemSelected:
                    _handleTabSelection,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
