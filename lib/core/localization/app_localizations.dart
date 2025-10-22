class AppLocalizations {
  static const Map<String, Map<String, String>> translations = {
    'en': {
      'chooseLanguage': 'Choose your Language',
      'selectLanguageDescription': 'Select the language you\'re most comfortable with to continue using the platform smoothly.',
      'language': 'language',
      'continue': 'Continue',
      'continueWith': 'Continue With',
      'gujarati': 'Gujarati',
      'english': 'English',
      'welcome': 'Welcome',
      'home': 'Home',
      'settings': 'Settings',
      'profile': 'Profile',
      'logout': 'Logout',
    },
    'gu': {
      'chooseLanguage': 'તમારી ભાષા પસંદ કરો',
      'selectLanguageDescription': 'પ્લેટફોર્મને સરળતાથી ઉપયોગ કરવા માટે તમે સૌથી વધુ આરામદાયક ભાષા પસંદ કરો.',
      'language': 'ભાષા',
      'continue': 'ચાલુ રાખો',
      'continueWith': 'સાથે ચાલુ રાખો',
      'gujarati': 'ગુજરાતી',
      'english': 'અંગ્રેજી',
      'welcome': 'સ્વાગત',
      'home': 'ઘર',
      'settings': 'સેટિંગ્સ',
      'profile': 'પ્રોફાઇલ',
      'logout': 'લોગઆઉટ',
    },
  };

  static String getText(String key, String languageCode) {
    return translations[languageCode]?[key] ?? translations['en']![key]!;
  }
}
