import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:test/core/utility/constants.dart';
import 'package:test/localization%20provider/localization_provider.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
              color: appColorLightGrey,
              borderRadius: BorderRadius.all(Radius.circular(10.r))),
          height: 70.h,
          width: 250.w,
          child: Center(
            child: DropdownButton<Locale>(
              value: Provider.of<LocalizationProvider>(context).locale,
              icon: const Icon(Icons.language),
              onChanged: (Locale? newLocale) {
                if (newLocale != null) {
                  Provider.of<LocalizationProvider>(context, listen: false)
                      .setLocale(newLocale);
                }
              },
              items: L10n.all.map<DropdownMenuItem<Locale>>((Locale locale) {
                return DropdownMenuItem<Locale>(
                  value: locale,
                  child: Text(
                    L10n.getFlag(locale.languageCode),
                    style: TextStyle(fontSize: 20.sp),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
