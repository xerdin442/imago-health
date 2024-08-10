import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/utility/constants.dart';

class CarouselContent extends StatelessWidget {
  const CarouselContent(
      {super.key,
      required this.imageLink,
      required this.imgtext,
      required this.imgDesc});

  final String imageLink;
  final String imgtext;
  final String imgDesc;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          height: 500.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25.r),
                bottomRight: Radius.circular(25.r)),
            color: const Color(0xff9169C1).withOpacity(0.8),
            image: DecorationImage(
              image: AssetImage(imageLink),
              colorFilter: ColorFilter.mode(
                const Color(0xff9169C1).withOpacity(0.4),
                BlendMode.dstATop,
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Text(
          "   Welcome",
          style: fontStyle.copyWith(
              color: appColorLightPurple,
              fontSize: 30.sp,
              fontWeight: FontWeight.w600),
        ),
        Text(
          "      $imgtext",
          style: fontStyle.copyWith(
              color: appColorGreyBlack.withOpacity(0.8),
              fontSize: 20.sp,
              fontWeight: FontWeight.w100),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          child: Text(
            imgDesc,
            style: TextStyle(
              fontSize: 12.sp,
              fontFamily: 'Poppins',
            ),
          ),
        )
      ],
    );
  }
}
