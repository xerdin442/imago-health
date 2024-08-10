import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/utility/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil
    ScreenUtil.init(context);

    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: appColorWhite,
      body: SizedBox(
        height: 1.sh,
        width: 1.sw,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 1.sh,
                child: Stack(children: [
                  Container(
                    height: 0.7.sh,
                    width: 1.sw,
                    decoration: BoxDecoration(
                      color: const Color(0xff9169C1).withOpacity(0.8),
                      image: DecorationImage(
                        image: const AssetImage("assets/images/hand.png"),
                        colorFilter: ColorFilter.mode(
                          const Color(0xff9169C1).withOpacity(0.4),
                          BlendMode.dstATop,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0.13.sh,
                    right: 0.03.sw,
                    left: 0,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0.05.sw),
                      child: Column(
                        children: [
                          Text(
                            "IMAGO",
                            style: TextStyle(
                                fontSize: 70.sp,
                                fontWeight: FontWeight.w900,
                                color: appColorWhite,
                                fontFamily: 'Kanit'),
                          ),
                          Text(
                            localizations.welcomeSubtitle,
                            style: TextStyle(
                                fontSize: 30.sp,
                                color: appColorWhite,
                                fontStyle: FontStyle.italic),
                          )
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0.6.sh,
                    right: 0,
                    left: 0,
                    child: Container(
                      height: 0.5.sh,
                      transform: Matrix4.translationValues(0, 0.01.sw, 0),
                      decoration: const BoxDecoration(
                        color: appColorWhite,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 0.1.sw),
                        child: SizedBox(
                          width: 1.sw,
                          height: 0.4.sh,
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 0.04.sh,
                                ),
                                _buildLoginButton(context, localizations),
                                SizedBox(height: 0.02.sh),
                                _buildRegisterButton(context, localizations)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context, AppLocalizations localizations) {
    return SizedBox(
      height: 60.h, // Use ScreenUtil height units
      width: 0.7.sw,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, 'login');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: appColorLightPurple,
        ),
        child: Center(
          child: Text(
            localizations.loginButton,
            style: TextStyle(
                color: appColorWhite,
                fontSize: 20.sp), // Use ScreenUtil font size units
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterButton(BuildContext context, AppLocalizations localizations) {
    return SizedBox(
      height: 60.h, // Use ScreenUtil height units
      width: 0.7.sw,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, 'register');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: appColorDarkPurple,
        ),
        child: Text(
          localizations.registerButton,
          style: TextStyle(
              color: appColorWhite,
              fontSize: 20.sp), // Use ScreenUtil font size units
        ),
      ),
    );
  }
}
