/// Example usage of LanguagePreference utility
/// 
/// This file demonstrates how to use LanguagePreference in your screens
/// to get the selected language's med_id and other information.

import 'language_preference.dart';

/// Example: Get selected medium ID in any screen
/// 
/// ```dart
/// // Get the selected med_id
/// final medId = await LanguagePreference.getSelectedMediumId();
/// if (medId != null) {
///   // Use med_id in API calls
///   print('Selected Medium ID: $medId');
/// }
/// ```
/// 
/// Example: Get all medium information
/// 
/// ```dart
/// // Get all saved medium information
/// final mediumInfo = await LanguagePreference.getSelectedMediumInfo();
/// final medId = mediumInfo['med_id'];
/// final name = mediumInfo['name'];
/// final shortName = mediumInfo['short_name'];
/// final languageCode = mediumInfo['language_code'];
/// 
/// // Use in API calls
/// if (medId != null) {
///   // Make API call with med_id
///   await apiService.getData(mediumId: medId);
/// }
/// ```
/// 
/// Example: Check if language is selected
/// 
/// ```dart
/// // Check if user has selected a language
/// final hasLanguage = await LanguagePreference.hasSelectedMedium();
/// if (hasLanguage) {
///   // User has selected a language
///   final medId = await LanguagePreference.getSelectedMediumId();
/// } else {
///   // Show language selection screen
/// }
/// ```
/// 
/// Example: Clear selected language (e.g., on logout)
/// 
/// ```dart
/// // Clear saved language
/// await LanguagePreference.clearSelectedMedium();
/// ```

