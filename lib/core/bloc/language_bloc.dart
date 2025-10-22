import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Language enum
enum AppLanguage {
  english('en', 'English'),
  gujarati('gu', 'ગુજરાતી');

  const AppLanguage(this.code, this.displayName);
  final String code;
  final String displayName;
}

// Language BLoC Events
abstract class LanguageEvent {}

class LoadLanguage extends LanguageEvent {}

class ChangeLanguage extends LanguageEvent {
  final AppLanguage language;
  ChangeLanguage(this.language);
}

// Language BLoC States
abstract class LanguageState {}

class LanguageInitial extends LanguageState {}

class LanguageLoaded extends LanguageState {
  final AppLanguage currentLanguage;
  final Locale locale;
  
  LanguageLoaded({
    required this.currentLanguage,
    required this.locale,
  });
}

class LanguageChanged extends LanguageState {
  final AppLanguage newLanguage;
  final Locale locale;
  
  LanguageChanged({
    required this.newLanguage,
    required this.locale,
  });
}

// Language BLoC
class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  static const String _languageKey = 'selected_language';
  
  LanguageBloc() : super(LanguageInitial()) {
    on<LoadLanguage>(_onLoadLanguage);
    on<ChangeLanguage>(_onChangeLanguage);
  }

  Future<void> _onLoadLanguage(LoadLanguage event, Emitter<LanguageState> emit) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString(_languageKey) ?? 'en';
      
      final language = AppLanguage.values.firstWhere(
        (lang) => lang.code == languageCode,
        orElse: () => AppLanguage.english,
      );
      
      emit(LanguageLoaded(
        currentLanguage: language,
        locale: Locale(language.code),
      ));
    } catch (e) {
      // Default to English if error
      emit(LanguageLoaded(
        currentLanguage: AppLanguage.english,
        locale: const Locale('en'),
      ));
    }
  }

  Future<void> _onChangeLanguage(ChangeLanguage event, Emitter<LanguageState> emit) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, event.language.code);
      
      emit(LanguageChanged(
        newLanguage: event.language,
        locale: Locale(event.language.code),
      ));
    } catch (e) {
      // Handle error if needed
    }
  }
}

// Language Repository
class LanguageRepository {
  static const String _languageKey = 'selected_language';
  
  static Future<AppLanguage> getCurrentLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_languageKey) ?? 'en';
    
    return AppLanguage.values.firstWhere(
      (lang) => lang.code == languageCode,
      orElse: () => AppLanguage.english,
    );
  }
  
  static Future<void> saveLanguage(AppLanguage language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, language.code);
  }
}
