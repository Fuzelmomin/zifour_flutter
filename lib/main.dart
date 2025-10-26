import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                ),
                home: const SplashScreen(), // Start with splash screen
              );
            },
          );
        },
      ),
    );
  }
}
