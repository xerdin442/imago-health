import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:test/core/services/chat%20id%20services/emergency_chat_id_service.dart';
import 'package:test/core/services/chat%20id%20services/non_binary_chat_id_service.dart';
import 'package:test/core/services/chat%20id%20services/symptom_chat_id_service.dart';
import 'package:test/core/services/chat%20id%20services/women_health_chat_id_service.dart';
import 'package:test/core/utility/constants.dart';
import 'package:test/view%20model/addiction%20view%20model/addition_chat_id_provider.dart';
import 'package:test/view%20model/emegency%20view%20model/emergency_chat_id_provider.dart';
import 'package:test/view%20model/non%20binary%20view%20model/non_binary_chat_id_provider.dart';
import 'package:test/view%20model/symptom%20view%20model/symptom_chat_id_provider.dart';
import 'package:test/view%20model/women%20health%20view%20model/women_health_chat_id_provider.dart';
import 'package:test/widgets/build_title.dart';
import 'package:test/widgets/colored_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/services/chat id services/addiction_chat_id_service.dart';

class HomepageScreen extends StatefulWidget {
  const HomepageScreen({super.key});

  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  List<bool> isLoading = List.filled(8, false);

  List<String> imageLinks = [
    "assets/images/emergency.png",
    "assets/images/mdi_doc.png",
    "assets/images/drugs.png",
    "assets/images/non-binary.png",
    "assets/images/female-icon.png",
    "assets/images/head.png",
    "assets/images/eye.png",
    "assets/images/ear.png",
  ];

  
  List<Color> cardColors = [
      appColorDarkPurple,
      appColorLightPurple,
      appColorLightPurple,
      appColorDarkPurple,
      appColorDarkPurple,
      appColorLightPurple,
      appColorLightPurple,
      appColorDarkPurple
    ];

    
  List<String> routes = [
      "emergency",
      "symptomChatBot",
      "vetdrug",
      "nonBinary",
      "womenHealth",
      "addiction",
      "home",
      "home",
    ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();    
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
       List<String> cardText = [
      localizations.emergency,
      localizations.symptomChecker,
      localizations.vetDrug,
      localizations.nonBinaryMentalHealth,
      localizations.womensHealth,
      localizations.addictionTreatment,
      localizations.visualSensoryAssistant,
      localizations.hearingAssistant,
    ];
    final emergencyChatIdProvider =
        Provider.of<EmergencyChatIdProvider>(context);
    final symptomsChatIdProvider = Provider.of<SymptomChatIdProvider>(context);
    final addictionChatIdProvider =
        Provider.of<AddictionChatIdProvider>(context);
    final nonBinaryChatIdProvider =
        Provider.of<NonBinaryChatIdProvider>(context);
    final womenHealthChatIdProvider =
        Provider.of<WomenHealthChatIdProvider>(context);

    final List<Function> functions = [
      () async =>
          await EmergencyChatIdService(emergencyChatIdProvider).getChatId(),
      () async => await SymptomCheckerChatIdServices(symptomsChatIdProvider)
          .getChatId(),
      () async => Navigator.pushNamed(context, 'vetdrug'),
      () async =>
          await NonBinaryChatIdService(nonBinaryChatIdProvider).getChatId(),
      () async =>
          await WomenHealthChatIdService(womenHealthChatIdProvider).getChatId(),
      () async =>
          await AddictionChatIdService(addictionChatIdProvider).getChatId(),
      () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Center(child: Text(AppLocalizations.of(context)!.comingSoon)),
          ),
        );
      },
      () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Center(child: Text(AppLocalizations.of(context)!.comingSoon)),
          ),
        );
      },
    ];

    return Scaffold(
      body: SizedBox(
        height: 1.sh,
        width: 1.sw,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(15.0.dm),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomTitle(
                      context: context,
                      text: AppLocalizations.of(context)!.welcome),
                  CircleAvatar(
                    backgroundColor: appColorLightPurple,
                    radius: 20.r,
                    child: Icon(
                      Icons.account_circle,
                      size: 30.r,
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              top: 60.h,
              child: SizedBox(
                height: 0.77.sh,
                width: 1.sw,
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 0.01.sw,
                    mainAxisExtent: 0.39.sw,
                  ),
                  itemCount: imageLinks.length,
                  itemBuilder: (context, index) {
                    return ColoredCard(
                      isLoading: isLoading[index],
                      imgLink: imageLinks[index],
                      text: cardText[index],
                      cardColor: cardColors[index],
                      textColor: appColorWhite,
                      onButtonPressed: () async {
                        setState(() {
                          isLoading[index] = true;
                        });

                        try {
                          await functions[index]();
                          setState(() {
                            isLoading[index] = false;
                          });

                          Navigator.pushNamed(context, routes[index]);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Center(
                                  child: Text("An error occured")),
                            ),
                          );
                          setState(() {
                            isLoading[index] = false;
                          });
                        }
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
