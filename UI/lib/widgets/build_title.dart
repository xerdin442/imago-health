import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/utility/constants.dart';

class CustomTitle extends StatelessWidget {
  const CustomTitle({
    super.key,
    required this.context,
    required this.text,
  });

  final BuildContext context;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: fontStyle.copyWith(
        fontSize: 25.sp,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
