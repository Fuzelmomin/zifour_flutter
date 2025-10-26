import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/language_bloc.dart';
import 'app_localizations.dart';

extension LocalizationExtension on BuildContext {
  /// Get localized text based on current language
  String localize(String key) {
    final state = read<LanguageBloc>().state;
    String languageCode = 'en';
    
    if (state is LanguageLoaded) {
      languageCode = state.currentLanguage.code;
    } else if (state is LanguageChanged) {
      languageCode = state.newLanguage.code;
    }
    
    return AppLocalizations.getText(key, languageCode);
  }
}
