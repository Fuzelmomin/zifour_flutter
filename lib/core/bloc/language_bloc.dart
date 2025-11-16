import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api_models/medium_model.dart';
import '../api_models/api_status.dart';
import '../repositories/language_repository.dart' as api_repo;
import '../utils/connectivity_service.dart';
import '../utils/language_preference.dart';

// Language enum
enum AppLanguage {
  english('en', 'English'),
  gujarati('gu', 'ગુજરાતી');

  const AppLanguage(this.code, this.displayName);
  final String code;
  final String displayName;

  // Factory method to create from MediumModel
  static AppLanguage? fromMediumModel(MediumModel medium) {
    final shortName = medium.shortName.toUpperCase();
    if (shortName == 'EN') {
      return AppLanguage.english;
    } else if (shortName == 'GUJ') {
      return AppLanguage.gujarati;
    }
    // Map based on name if short_name doesn't match
    if (medium.name.toLowerCase().contains('english')) {
      return AppLanguage.english;
    } else if (medium.name.toLowerCase().contains('gujarati')) {
      return AppLanguage.gujarati;
    }
    return null;
  }
}

// Language BLoC Events
abstract class LanguageEvent {}

class LoadLanguage extends LanguageEvent {}

class FetchLanguages extends LanguageEvent {}

class ChangeLanguage extends LanguageEvent {
  final AppLanguage language;
  ChangeLanguage(this.language);
}

class SelectLanguageFromMedium extends LanguageEvent {
  final MediumModel medium;
  SelectLanguageFromMedium(this.medium);
}

// Language BLoC States
abstract class LanguageState {}

class LanguageInitial extends LanguageState {}

class LanguageLoading extends LanguageState {}

class LanguagesFetched extends LanguageState {
  final List<MediumModel> mediums;
  final AppLanguage? currentLanguage;
  final MediumModel? currentMedium;
  final Locale locale;
  
  LanguagesFetched({
    required this.mediums,
    this.currentLanguage,
    this.currentMedium,
    required this.locale,
  });
}

class LanguageLoaded extends LanguageState {
  final AppLanguage currentLanguage;
  final Locale locale;
  final List<MediumModel>? mediums;
  
  LanguageLoaded({
    required this.currentLanguage,
    required this.locale,
    this.mediums,
  });
}

class LanguageChanged extends LanguageState {
  final AppLanguage newLanguage;
  final MediumModel? newMedium;
  final Locale locale;
  final List<MediumModel>? mediums;
  
  LanguageChanged({
    required this.newLanguage,
    this.newMedium,
    required this.locale,
    this.mediums,
  });
}

class LanguageError extends LanguageState {
  final String message;
  
  LanguageError(this.message);
}

class NoInternetState extends LanguageState {}

// Language BLoC
class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  static const String _languageKey = 'selected_language';
  final api_repo.MediumRepository _mediumRepository = api_repo.MediumRepository();
  final ConnectivityService _connectivityService = ConnectivityService();
  List<MediumModel>? _availableMediums;
  StreamSubscription<bool>? _connectivitySubscription;
  
  LanguageBloc() : super(LanguageInitial()) {
    on<LoadLanguage>(_onLoadLanguage);
    on<FetchLanguages>(_onFetchLanguages);
    on<ChangeLanguage>(_onChangeLanguage);
    on<SelectLanguageFromMedium>(_onSelectLanguageFromMedium);
    
    // Listen to connectivity changes
    _listenToConnectivity();
  }
  
  void _listenToConnectivity() {
    // Initialize connectivity service
    _connectivityService.initialize();
    
    // Listen to connectivity stream
    _connectivitySubscription = _connectivityService.connectivityStream.listen(
      (isConnected) {
        // If internet is restored and we're in NoInternetState, automatically retry
        if (isConnected && state is NoInternetState) {
          add(FetchLanguages());
        }
      },
    );
  }
  
  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
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

  Future<void> _onFetchLanguages(FetchLanguages event, Emitter<LanguageState> emit) async {
    // Check connectivity before making API call
    final isConnected = await _connectivityService.checkConnectivity();
    
    if (!isConnected) {
      emit(NoInternetState());
      return;
    }
    
    emit(LanguageLoading());
    
    try {
      final response = await _mediumRepository.getMediumLanguages();
      
      if (response.status == ApiStatus.success && response.data != null) {
        _availableMediums = response.data!.mediumList;
        
        // Load current saved medium using med_id from SharedPreferences
        final savedMedId = await LanguagePreference.getSelectedMediumId();
        MediumModel? currentMedium;
        AppLanguage? currentLanguage;
        
        if (savedMedId != null && savedMedId.isNotEmpty) {
          // Find medium by saved med_id
          currentMedium = LanguagePreference.findMediumById(_availableMediums!, savedMedId);
          
          if (currentMedium != null) {
            currentLanguage = AppLanguage.fromMediumModel(currentMedium);
          }
        }
        
        // If no saved medium found, try to load by language code (backward compatibility)
        if (currentMedium == null) {
          final prefs = await SharedPreferences.getInstance();
          final languageCode = prefs.getString(_languageKey) ?? 'en';
          
          for (var medium in _availableMediums!) {
            final appLang = AppLanguage.fromMediumModel(medium);
            if (appLang != null && appLang.code == languageCode) {
              currentLanguage = appLang;
              currentMedium = medium;
              break;
            }
          }
        }
        
        // Default to first available language if no saved language found
        if (currentMedium == null && _availableMediums!.isNotEmpty) {
          currentMedium = _availableMediums!.first;
          currentLanguage = AppLanguage.fromMediumModel(currentMedium) ?? AppLanguage.english;
        } else if (currentLanguage == null) {
          currentLanguage = AppLanguage.english;
        }
        
        emit(LanguagesFetched(
          mediums: _availableMediums!,
          currentLanguage: currentLanguage,
          currentMedium: currentMedium,
          locale: Locale(currentLanguage.code),
        ));
      } else {
        emit(LanguageError(response.errorMsg ?? 'Failed to fetch languages'));
      }
    } catch (e) {
      // Check if it's a network error
      final isStillConnected = await _connectivityService.checkConnectivity();
      if (!isStillConnected) {
        emit(NoInternetState());
      } else {
        emit(LanguageError('Error fetching languages: ${e.toString()}'));
      }
    }
  }

  Future<void> _onChangeLanguage(ChangeLanguage event, Emitter<LanguageState> emit) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, event.language.code);
      
      emit(LanguageChanged(
        newLanguage: event.language,
        locale: Locale(event.language.code),
        mediums: _availableMediums,
      ));
    } catch (e) {
      emit(LanguageError('Error changing language: ${e.toString()}'));
    }
  }

  Future<void> _onSelectLanguageFromMedium(SelectLanguageFromMedium event, Emitter<LanguageState> emit) async {
    try {
      final appLanguage = AppLanguage.fromMediumModel(event.medium);
      
      if (appLanguage != null) {
        // Save med_id and other medium info to SharedPreferences using LanguagePreference
        final saved = await LanguagePreference.saveSelectedMedium(
          event.medium,
          appLanguage.code,
        );
        
        if (saved) {
          emit(LanguageChanged(
            newLanguage: appLanguage,
            newMedium: event.medium,
            locale: Locale(appLanguage.code),
            mediums: _availableMediums,
          ));
        } else {
          emit(LanguageError('Failed to save selected language'));
        }
      } else {
        emit(LanguageError('Unable to map medium to language'));
      }
    } catch (e) {
      emit(LanguageError('Error selecting language: ${e.toString()}'));
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
