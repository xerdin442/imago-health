import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:test/core/utility/constants.dart';
import 'package:test/localization%20provider/localization_provider.dart';

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
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
                      Navigator.pushNamed(context, 'carousel');
                    }
                  },
                  items:
                      L10n.all.map<DropdownMenuItem<Locale>>((Locale locale) {
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: Text(
                textAlign: TextAlign.center,
                "Note some part of the app may remain fundamentally in English",
                style: TextStyle(color: appColorDarkPurple, fontSize: 15.sp),
              ),
            )
          ],
        ),
      ),
    );
  }
}
