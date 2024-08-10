import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/utility/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import generated localizations

class CautionScreen extends StatefulWidget {
  const CautionScreen({super.key});

  @override
  State<CautionScreen> createState() => _CautionScreenState();
}

class _CautionScreenState extends State<CautionScreen> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: 1.sh,
          width: 1.sw,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(top: 20.h),
              child: Column(
                children: [
                  _buildImage(),
                  _buildWelcomeText(localizations!),
                  _buildDescription(localizations),
                  _buildPolicyText(localizations),
                  _buildGetStartedButton(context, localizations)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Container(
      height: 300.h,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/polygon.png"),
        ),
      ),
      child: Center(
        child: Image.asset("assets/images/sign.png"),
      ),
    );
  }

  Widget _buildWelcomeText(AppLocalizations localizations) {
    return Padding(
      padding: EdgeInsets.only(top: 20.h),
      child: Text(
        localizations.caution_title,
        style: fontStyle.copyWith(
            color: appColorLightPurple,
            fontSize: 30.sp,
            fontWeight: FontWeight.w600,
            fontFamily: 'Kanit'),
      ),
    );
  }

  Widget _buildDescription(AppLocalizations localizations) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 15.h),
      child: Text(
        localizations.caution_description,
        style: TextStyle(fontSize: 15.sp),
      ),
    );
  }

  Widget _buildPolicyText(AppLocalizations localizations) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.h),
      child: Column(
        children: [
          Text(
            "${localizations.caution_policy_agreement}               ",
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 15.sp),
          ),
          Container(
            padding: EdgeInsets.only(left: 45.w),
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () {},
              child: Text(
                localizations.caution_terms_and_policy,
                style: TextStyle(fontSize: 15.sp, color: appColorLightPurple),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildGetStartedButton(BuildContext context, AppLocalizations localizations) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushReplacementNamed(context, 'option');
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 15.h),
        backgroundColor: appColorLightPurple,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.r),
        ),
      ),
      child: Text(
        localizations.caution_get_started,
        style: fontStyle.copyWith(
          color: Colors.white,
          fontSize: 16.sp,
        ),
      ),
    );
  }
}
