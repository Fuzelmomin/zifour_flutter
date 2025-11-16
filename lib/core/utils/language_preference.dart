import 'package:shared_preferences/shared_preferences.dart';
import '../api_models/medium_model.dart';

/// Utility class for managing selected language in SharedPreferences
/// Stores and retrieves the med_id of the selected language
class LanguagePreference {
  static const String _selectedMediumIdKey = 'selected_medium_id';
  static const String _selectedMediumNameKey = 'selected_medium_name';
  static const String _selectedMediumShortNameKey = 'selected_medium_short_name';
  static const String _selectedLanguageCodeKey = 'selected_language_code';

  /// Save the selected medium (language) to SharedPreferences
  static Future<bool> saveSelectedMedium(MediumModel medium, String languageCode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Save med_id, name, short_name, and language code
      await prefs.setString(_selectedMediumIdKey, medium.medId);
      await prefs.setString(_selectedMediumNameKey, medium.name);
      await prefs.setString(_selectedMediumShortNameKey, medium.shortName);
      await prefs.setString(_selectedLanguageCodeKey, languageCode);
      
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get the saved medium ID from SharedPreferences
  static Future<String?> getSelectedMediumId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_selectedMediumIdKey);
    } catch (e) {
      return null;
    }
  }

  /// Get the saved medium name from SharedPreferences
  static Future<String?> getSelectedMediumName() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_selectedMediumNameKey);
    } catch (e) {
      return null;
    }
  }

  /// Get the saved medium short name from SharedPreferences
  static Future<String?> getSelectedMediumShortName() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_selectedMediumShortNameKey);
    } catch (e) {
      return null;
    }
  }

  /// Get the saved language code from SharedPreferences
  static Future<String?> getSelectedLanguageCode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_selectedLanguageCodeKey);
    } catch (e) {
      return null;
    }
  }

  /// Get all saved medium information as a map
  static Future<Map<String, String?>> getSelectedMediumInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return {
        'med_id': prefs.getString(_selectedMediumIdKey),
        'name': prefs.getString(_selectedMediumNameKey),
        'short_name': prefs.getString(_selectedMediumShortNameKey),
        'language_code': prefs.getString(_selectedLanguageCodeKey),
      };
    } catch (e) {
      return {
        'med_id': null,
        'name': null,
        'short_name': null,
        'language_code': null,
      };
    }
  }

  /// Check if a medium is already saved
  static Future<bool> hasSelectedMedium() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(_selectedMediumIdKey) && 
             prefs.getString(_selectedMediumIdKey) != null;
    } catch (e) {
      return false;
    }
  }

  /// Clear the saved medium (logout or reset)
  static Future<bool> clearSelectedMedium() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_selectedMediumIdKey);
      await prefs.remove(_selectedMediumNameKey);
      await prefs.remove(_selectedMediumShortNameKey);
      await prefs.remove(_selectedLanguageCodeKey);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Find MediumModel from list by med_id
  static MediumModel? findMediumById(List<MediumModel> mediums, String medId) {
    try {
      return mediums.firstWhere(
        (medium) => medium.medId == medId,
      );
    } catch (e) {
      return null;
    }
  }
}

