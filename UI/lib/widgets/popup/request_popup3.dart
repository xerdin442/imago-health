import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:test/view%20model/medical%20record%20view%20model/medical_record_provider.dart';
import 'package:test/core/utility/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ShowPopUp3 {
  void showPopUp(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ShowPopUp3Content(),
    );
  }
}

class _ShowPopUp3Content extends StatefulWidget {
  @override
  __ShowPopUp3ContentState createState() => __ShowPopUp3ContentState();
}

class __ShowPopUp3ContentState extends State<_ShowPopUp3Content>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    )..addListener(() {
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
          child: Container(
            height: 300.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
            ),
            padding: EdgeInsets.all(18.dm),
            child: Wrap(
              children: [
                _buildContent(context, localizations!),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, AppLocalizations localizations) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildImage(),
        SizedBox(height: 5.h),
        _buildText(localizations),
        SizedBox(height: 15.h),
        _buildNextButton(context, localizations),
      ],
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
      localizations.getStartedPrompt,
      style: TextStyle(
          fontSize: 18.sp,
          color: appColorGreyBlack,
          fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildNextButton(
      BuildContext context, AppLocalizations localizations) {
    final medicalProvider = Provider.of<MedicalRecordProvider>(context);
    return SizedBox(
      height: 0.06.sh,
      width: 0.6.sw,
      child: MaterialButton(
        elevation: 5,
        onPressed: () async {
          setState(() {
            _isLoading = true;
          });

          setState(
            () {
              _isLoading = true;
            },
          );
          Navigator.pop(context);
          Future.microtask(() {
            Navigator.pushNamedAndRemoveUntil(
              context,
              'home',
              (Route<dynamic> route) => false,
            );
          });
        },
        color: appColorLightPurple,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
          Radius.circular(20.r),
        )),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (_isLoading)
              CupertinoActivityIndicator(
                radius: 20.r,
              ),
            if (!_isLoading)
              Text(
                localizations.getStartedButton,
                style: TextStyle(color: appColorWhite, fontSize: 18.sp),
              ),
          ],
        ),
      ),
    );
  }
}
