import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:test/localization%20provider/localization_provider.dart';
import 'package:test/view%20model/addiction%20view%20model/addiction_chat_history_provider.dart';
import 'package:test/view%20model/addiction%20view%20model/addition_chat_id_provider.dart';
import 'package:test/view%20model/drug%20vetting%20view%20model/drug_vetting_chat_provider.dart';
import 'package:test/view%20model/emegency%20view%20model/emergency_chat_history_provider.dart';
import 'package:test/view%20model/emegency%20view%20model/emergency_chat_id_provider.dart';
import 'package:test/view%20model/medical%20record%20view%20model/medical_record_provider.dart';
import 'package:test/view%20model/newsletter%20view%20model/newsletter_provider.dart';
import 'package:test/view%20model/non%20binary%20view%20model/non_binary_chat_history_provider.dart';
import 'package:test/view%20model/non%20binary%20view%20model/non_binary_chat_id_provider.dart';
import 'package:test/view%20model/symptom%20view%20model/symptom_chat_history_provider.dart';
import 'package:test/view%20model/symptom%20view%20model/symptom_chat_id_provider.dart';
import 'package:test/view%20model/women%20health%20view%20model/women_health_chat_history_provider.dart';
import 'package:test/view%20model/women%20health%20view%20model/women_health_chat_id_provider.dart';
import 'package:test/views/addiction/addition_chatbot.dart';
import 'package:test/views/auth/login_screen.dart';
import 'package:test/views/auth/medical_record_screen1.dart';
import 'package:test/views/auth/medical_record_screen2.dart';
import 'package:test/views/auth/register_screen.dart';
import 'package:test/views/auth/welcome_screen.dart';
import 'package:test/views/drug%20vetting/drug_vetting_chatbot.dart';
import 'package:test/views/drug%20vetting/drug_vetting_screen.dart';
import 'package:test/views/emergency/emergency_chatbot.dart';
import 'package:test/views/non%20binary/non_binary_chatbot.dart';
import 'package:test/views/splash/select_language_screen.dart';
import 'package:test/views/symptom%20checker/symptom_chat_bot.dart';
import 'package:test/views/emergency/emergency_screen.dart';
import 'package:test/views/home/home.dart';
import 'package:test/views/home/homepage_screen.dart';
import 'package:test/views/newsletter/newsletter_screen.dart';
import 'package:test/views/splash/caution_screen.dart';
import 'package:test/views/splash/splash_carousel_screen.dart';
import 'package:test/views/splash/splash_screen.dart';
import 'package:test/views/women%20health/women_health_chatbot.dart';
import 'core/utility/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => SymptomChatHistoryProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => SymptomChatIdProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => EmergencyChatHistoryProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => EmergencyChatIdProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => MedicalRecordProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => DrugVettingChatProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => NewsletterProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AddictionChatIdProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AddictionChatHistoryProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => NonBinaryChatIdProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => NonBinaryChatHistoryProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => WomenHealthChatIdProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => WomenHealthChatHistoryProvider(),
        ),
                ChangeNotifierProvider(
          create: (_) => LocalizationProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      useInheritedMediaQuery: true,
      minTextAdapt: true,
      child: Consumer<LocalizationProvider>(
        builder: (context, localizationProvider, child) {
          return MaterialApp(
            title: "Imago",
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primaryColor: appColorLightPurple,
              useMaterial3: true,
              scaffoldBackgroundColor: appColorWhite,
            ),
              locale: localizationProvider.locale,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: L10n.all,
            initialRoute: '/',
            routes: {
              '/': (context) => SplashScreen(),
              'carousel': (context) => const SplashCarouselScreen(),
              'caution': (context) => const CautionScreen(),
              'option': (context) => const WelcomeScreen(),
              'login': (context) => const LoginScreen(),
              'register': (context) => const RegisterScreen(),
              'record1': (context) => MedicalRecordScreen1(),
              'record2': (context) => const MedicalRecordScreen2(),
              'homepage': (context) => HomepageScreen(),
              'home': (context) => const Home(),
              'symptomChatBot': (context) => const SymptomChatBot(),
              'newsletter': (context) => const NewsletterScreen(),
              'emergency': (context) => const EmergencyScreen(),
              'emergencyChatBot': (context) => const EmergencyChatbot(),
              'vetdrug': (context) => const DrugVettingScreen(),
              'vetchat': (context) => const DrugVettingChatbot(),
              'addiction': (context) => const AddictionChatBot(),
              'womenHealth': (context) => const WomenHealthChatbot(),
              'nonBinary': (context) => const NonBinaryChatbot(),
              'selectLanguage': (context) => const LanguageSwitcher(),
            },
          );
        }
      ),
    );
  }
}
