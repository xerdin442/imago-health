// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/core/utility/config.dart';
import 'package:test/core/utility/constants.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();

    Future.delayed(const Duration(seconds: 7), () {
      _isLoggedIn
          ? Navigator.pushReplacementNamed(context, 'home')
          : Navigator.pushReplacementNamed(context, 'selectLanguage');
    });
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    setState(() {
      _isLoggedIn = isLoggedIn;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextLiquidFill(
          text: 'Imago',
          waveColor: appColorLightPurple,
          boxBackgroundColor: appColorWhite,
          textStyle: TextStyle(
            fontSize: 60.0.sp,
            fontFamily: 'Kanit',
            fontWeight: FontWeight.bold,
          ),
          boxHeight: deviceHeight(context),
          boxWidth: 500.w,
        ),
      ),
    );
  }
}
