import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/utility/config.dart';
import 'package:test/core/utility/constants.dart';
import 'package:test/widgets/carousel/splash_carousel_content.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import generated localizations

class SplashCarouselScreen extends StatefulWidget {
  const SplashCarouselScreen({super.key});

  @override
  _SplashCarouselScreenState createState() => _SplashCarouselScreenState();
}

class _SplashCarouselScreenState extends State<SplashCarouselScreen> {
  final CarouselController _carouselController = CarouselController();
  int _currentIndex = 0;

  List<Widget> _carouselItems = [];
  

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final localizations = AppLocalizations.of(context);

    _carouselItems = [
      CarouselContent(
        imageLink: 'assets/images/Group1.png',
        imgtext: localizations!.carousel1_imgtext,
        imgDesc: localizations.carousel1_imgDesc,
      ),
      CarouselContent(
        imageLink: 'assets/images/Group3.png',
        imgtext: localizations.carousel3_imgtext,
        imgDesc: localizations.carousel3_imgDesc,
      ),
      CarouselContent(
        imageLink: 'assets/images/love.png',
        imgtext: localizations.carousel4_imgtext,
        imgDesc: localizations.carousel4_imgDesc,
      ),
      CarouselContent(
        imageLink: 'assets/images/blind.png',
        imgtext: localizations.carousel5_imgtext,
        imgDesc: localizations.carousel5_imgDesc,
      ),
      CarouselContent(
        imageLink: 'assets/images/emerg.png',
        imgtext: localizations.carousel6_imgtext,
        imgDesc: localizations.carousel6_imgDesc,
      ),
      CarouselContent(
        imageLink: 'assets/images/symptom.png',
        imgtext: localizations.carousel7_imgtext,
        imgDesc: localizations.carousel7_imgDesc,
      ),
    ];
  }

  void _navigateToNextScreen() {
    Navigator.pushReplacementNamed(context, 'caution');
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: appColorWhite,
      body: SizedBox(
        height: deviceHeight(context),
        width: deviceWidth(context),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CarouselSlider(
                items: _carouselItems,
                carouselController: _carouselController,
                options: CarouselOptions(
                  enlargeCenterPage: true,
                  height: 700.h,
                  viewportFraction: 1,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                ),
              ),
              _buildIndicatorAndButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIndicatorAndButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildIndicators(),
          _buildNextButton(),
        ],
      ),
    );
  }

  Widget _buildIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _carouselItems.asMap().entries.map((entry) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: _currentIndex == entry.key ? 24.0 : 12.0,
          height: 12.0.h,
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(6.0.r),
            color: _currentIndex == entry.key
                ? appColorLightPurple.withOpacity(0.9)
                : Colors.grey.withOpacity(0.4),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNextButton() {
    final localizations = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.all(16.0.dm),
      child: ElevatedButton(
        onPressed: () {
          if (_currentIndex == _carouselItems.length - 1) {
            // Navigate to the next screen if it's the last index
            _navigateToNextScreen();
          } else {
            // Otherwise, go to the next page
            _carouselController.nextPage(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInOut,
            );
          }
        },
        child: Text(
          localizations!.button_next,
          style: fontStyle,
        ),
      ),
    );
  }
}
