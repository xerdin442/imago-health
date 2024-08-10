import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/utility/constants.dart';
import 'package:test/widgets/popup/request_popup2.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ShowPopUp {
  void showPopUp(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _ShowPopUpContent();
      },
    );
  }
}

class _ShowPopUpContent extends StatefulWidget {
  @override
  __ShowPopUpContentState createState() => __ShowPopUpContentState();
}

class __ShowPopUpContentState extends State<_ShowPopUpContent>
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
      height: 300.h,
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
        localizations.stepIndicator,
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
      child: Image.asset("assets/images/like.png"),
    );
  }

  Widget _buildText(AppLocalizations localizations) {
    return Text(
      textAlign: TextAlign.center,
      localizations.registrationComplete,
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
              ShowPopUp2().showPopUp(context);
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
