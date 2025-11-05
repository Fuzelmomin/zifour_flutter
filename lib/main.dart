import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'l10n/app_localizations.dart';

void main() {
  runApp(const MyApp());
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

          return ScreenUtilInit(
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
                ),
                home: DashboardScreen(), // Start with splash screen
              );
            },
          );
        },
      ),
    );
  }
}
