import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:test/core/utility/constants.dart';
import 'package:test/view%20model/newsletter%20view%20model/newsletter_provider.dart';
import 'package:test/core/services/newsletter%20service/newsletter_service.dart';
import 'package:test/widgets/build_title.dart';

class NewsletterScreen extends StatelessWidget {
  const NewsletterScreen({super.key});

  Future<void> fetchNewsletters(BuildContext context) async {
    await NewsletterService().fetchNewsletters(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColorWhite,
        automaticallyImplyLeading: false,
        title: CustomTitle(context: context, text: "Newsletter"),
      ),
      body: FutureBuilder(
        future: fetchNewsletters(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return Consumer<NewsletterProvider>(
              builder: (context, provider, child) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 100.h),
                  child: ListView.builder(
                    itemCount: provider.newsletters.length,
                    itemBuilder: (context, index) {
                      final newsletter = provider.newsletters[index];
                      return ListTile(
                        title: Container(
                          padding: EdgeInsets.all(8.dm),
                          decoration: BoxDecoration(
                              color: appColorDarkPurple,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.r))),
                          child: Text(newsletter.title,
                              style: fontStyle.copyWith(
                                color: appColorWhite,
                                fontSize: 25.sp,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                        subtitle: Padding(
                          padding: EdgeInsets.all(8.0.dm),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10.h, horizontal: 20.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10.r),
                                bottomRight: Radius.circular(10.r),
                              ),
                              color: appColorLightPurple,
                            ),
                            child: Text(newsletter.body,
                                style: TextStyle(
                                  color: appColorWhite,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w500,
                                )),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
