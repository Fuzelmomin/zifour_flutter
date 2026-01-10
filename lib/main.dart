import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zifour_sourcecode/features/dashboard/dashboard_screen.dart';
import 'package:zifour_sourcecode/features/faq/faq_screen.dart';
import 'features/chatbot/chatbot_screen.dart';
import 'features/demo_ui.dart';
import 'features/leaderboard/leaderboard_screen.dart';
import 'features/learning_course/learning_course_list_screen.dart';
import 'features/learning_course/learning_course_screen.dart';
import 'features/live_class/live_class_details_screen.dart';
import 'features/live_class/live_class_screen.dart';
import 'features/mentor/mentors_videos_list_screen.dart';
import 'features/practics_mcq/question_mcq_screen.dart';
import 'features/practics_mcq/select_chapter_screen.dart';
import 'features/splash/splash_screen.dart';
import 'core/bloc/language_bloc.dart';
import 'core/bloc/welcome_bloc.dart';
import 'core/bloc/signup_bloc.dart';
import 'firebase_options.dart';
import 'l10n/app_localizations.dart';
import 'notificaiton/notification.dart';


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await PushNotificationService().initialize();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  requestNotificationPermissions();

  // Configure status bar globally to be visible with light icons
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const MyApp());
}

Future<void> requestNotificationPermissions() async {
  final PermissionStatus status = await Permission.notification.request();
  if (status.isGranted) {
    print('NOTIFICATION PERMISSION GRANTED');
    // Notification permissions granted
  } else if (status.isDenied) {
    // Notification permissions denied
    print('NOTIFICATION PERMISSION DENIYE');
  } else if (status.isPermanentlyDenied) {
    print('NOTIFICATION PERMISSION OPEN SETTING');
    // Notification permissions permanently denied, open app settings

    if (Platform.isAndroid) {
      await openAppSettings();
    }
  }
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LanguageBloc()),
        BlocProvider(create: (context) => WelcomeBloc()),
        BlocProvider(create: (context) => SignupBloc()),
      ],
      child: BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, state) {
          Locale locale = const Locale('en');
          if (state is LanguageLoaded) {
            locale = state.locale;
          } else if (state is LanguageChanged) {
            locale = state.locale;
          }

          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.dark,
              systemNavigationBarColor: Colors.transparent,
              systemNavigationBarIconBrightness: Brightness.light,
            ),
            child: ScreenUtilInit(
              designSize: const Size(375, 812), // iPhone X design size
              minTextAdapt: true,
              splitScreenMode: true,
              builder: (context, child) {
                return MaterialApp(
                title: 'Zifour',
                debugShowCheckedModeBanner: false,
                locale: locale,
                supportedLocales: AppLocalizations.supportedLocales,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                theme: ThemeData(
                  colorScheme:
                      ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                  useMaterial3: true,
                  menuTheme: MenuThemeData(
                    style: MenuStyle(
                      backgroundColor: MaterialStatePropertyAll(Color(0xFF2B1C4D)),
                      elevation: MaterialStatePropertyAll(10),
                      shape: MaterialStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  appBarTheme: const AppBarTheme(
                    systemOverlayStyle: SystemUiOverlayStyle(
                      statusBarColor: Colors.transparent,
                      statusBarIconBrightness: Brightness.light,
                      statusBarBrightness: Brightness.dark,
                    ),
                  ),
                ),
                builder: (context, child) {
                  return MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                      padding: EdgeInsets.zero,
                    ),
                    child: child!,
                  );
                },
                home: SplashScreen(), // Start with splash screen
              );
            },
            ),
          );
        },
      ),
    );
  }
}
