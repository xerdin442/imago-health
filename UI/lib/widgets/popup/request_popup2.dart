import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/utility/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ShowPopUp2 {
  void showPopUp(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _ShowPopUp2Content();
      },
    );
  }
}

class _ShowPopUp2Content extends StatefulWidget {
  @override
  __ShowPopUp2ContentState createState() => __ShowPopUp2ContentState();
}

class __ShowPopUp2ContentState extends State<_ShowPopUp2Content>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut))
      ..addListener(() {
        setState(() {});
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: _buildBottomSheetContent(context, localizations!),
        );
      },
    );
  }

  Widget _buildBottomSheetContent(
      BuildContext context, AppLocalizations localizations) {
    return Container(
      height: 320.h,
      padding: EdgeInsets.all(16.0.dm),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildStepIndicator(localizations),
          _buildImage(),
          SizedBox(height: 5.h),
          _buildText(localizations),
          SizedBox(height: 15.h),
          _buildNextButton(context, localizations),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(AppLocalizations localizations) {
    return Align(
      alignment: Alignment.topLeft,
      child: Text(
        localizations.stepIndicator2,
        style: TextStyle(
            fontSize: 15.sp,
            color: appColorGreyBlack,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildImage() {
    return SizedBox(
      height: 100.h,
      width: 100.w,
      child: Image.asset("assets/images/error.png"),
    );
  }

  Widget _buildText(AppLocalizations localizations) {
    return Text(
      localizations.medicalInfoPrompt,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 18.sp,
        color: appColorGreyBlack,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildNextButton(
      BuildContext context, AppLocalizations localizations) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 60.w),
      child: SizedBox(
        height: 0.06.sh,
        width: 150.w,
        child: MaterialButton(
          elevation: 5,
          onPressed: () {
            Navigator.pop(context);
            Future.microtask(() {
              Navigator.pushNamedAndRemoveUntil(
                context,
                'record1',
                (Route<dynamic> route) => false,
              );
            });
          },
          color: appColorLightPurple,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
            Radius.circular(20.r),
          )),
          child: Text(
            localizations.nextButton,
            style: TextStyle(color: appColorWhite, fontSize: 18.sp),
          ),
        ),
      ),
    );
  }
}
