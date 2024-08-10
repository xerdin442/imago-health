import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/utility/constants.dart';

class ColoredCard extends StatelessWidget {
  const ColoredCard({
    super.key,
    required this.imgLink,
    required this.text,
    required this.cardColor,
    required this.textColor,
    required this.onButtonPressed,
    required this.isLoading,
  });

  final String imgLink;
  final String text;
  final Color cardColor;
  final Color textColor;
  final VoidCallback onButtonPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onButtonPressed,
      child: Padding(
        padding: EdgeInsets.all(8.0.dm),
        child: Container(
          height: 150.h,
          width: 0.7.sw,
          decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.all(Radius.circular(20.r))),
          child: Padding(
            padding: EdgeInsets.all(2.dm),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 8.w),
                  height: 50.h,
                  child: Image.asset(imgLink),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5.w),
                  child: Text(
                    textAlign: TextAlign.start,
                    text,
                    style: TextStyle(
                        color: textColor,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                isLoading
                    ? Container(
                        padding: EdgeInsets.symmetric(horizontal: 2.dm),
                        alignment: Alignment.centerRight,
                        child: CupertinoActivityIndicator(
                          color: appColorWhite,
                        ),
                      )
                    : Container(
                        padding: EdgeInsets.symmetric(horizontal: 2.dm),
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.arrow_forward,
                          color: appColorWhite,
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
