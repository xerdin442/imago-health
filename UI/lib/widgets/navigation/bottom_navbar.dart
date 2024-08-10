import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/widgets/navigation/custom_navbar_Item.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import localization


class CustomFloatingNavBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const CustomFloatingNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  _CustomFloatingNavBarState createState() => _CustomFloatingNavBarState();
}

class _CustomFloatingNavBarState extends State<CustomFloatingNavBar> {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Container(
      height: 80.h,
      width: 350.w,
      margin: EdgeInsets.all(10.0.dm),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 5.r,
            blurRadius: 10.r,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30.0.r),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CustomNavBarItem(
                  icon: Icons.home,
                  label: localizations!.home,
                  isSelected: widget.selectedIndex == 0,
                  onTap: () {
                    widget.onItemSelected(0);
                  }),
              CustomNavBarItem(
                  label: localizations.healthTips,
                  icon: Icons.topic_sharp,
                  isSelected: widget.selectedIndex == 1,
                  onTap: () {
                    widget.onItemSelected(1);
                  }),
              CustomNavBarItem(
                  label: localizations.settings,
                  icon: Icons.settings,
                  isSelected: widget.selectedIndex == 2,
                  onTap: () {
                    widget.onItemSelected(2);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
