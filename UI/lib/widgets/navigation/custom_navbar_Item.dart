import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/utility/constants.dart';

class CustomNavBarItem extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final String label;

  const CustomNavBarItem({
    super.key,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? appColorLightPurple : appColorDarkPurple,
            size: 30.r,
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.sp,
              color: isSelected ? appColorLightPurple : appColorDarkPurple,
            ),
          ),
          if (isSelected)
            Padding(
              padding: EdgeInsets.only(top: 5.0.h),
              child: Container(
                height: 8.h,
                width: 8.w,
                decoration: const BoxDecoration(
                  color: appColorLightPurple,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
