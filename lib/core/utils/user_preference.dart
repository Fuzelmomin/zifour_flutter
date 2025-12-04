import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../api_models/login_model.dart';

/// Utility class for managing user data and login credentials in SharedPreferences
class UserPreference {
  // Keys for SharedPreferences
  static const String _rememberMeKey = 'remember_me';
  static const String _savedMobileKey = 'saved_mobile';
  static const String _savedPasswordKey = 'saved_password';
  static const String _userDataKey = 'user_data';
  static const String _isLoggedInKey = 'is_logged_in';

  /// ValueNotifier for real-time user data updates
  static final ValueNotifier<LoginData?> userNotifier = ValueNotifier(null);

  /// Initialize user data from SharedPreferences
  static Future<void> init() async {
    userNotifier.value = await getUserData();
  }

  /// Save remember me preference
  static Future<bool> saveRememberMe(bool rememberMe) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setBool(_rememberMeKey, rememberMe);
    } catch (e) {
      return false;
    }
  }

  /// Get remember me preference
  static Future<bool> getRememberMe() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_rememberMeKey) ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Save login credentials (mobile and password)
  static Future<bool> saveLoginCredentials({
    required String mobile,
    required String password,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_savedMobileKey, mobile);
      await prefs.setString(_savedPasswordKey, password);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get saved mobile number
  static Future<String?> getSavedMobile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_savedMobileKey);
    } catch (e) {
      return null;
    }
  }

  /// Get saved password
  static Future<String?> getSavedPassword() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_savedPasswordKey);
    } catch (e) {
      return null;
    }
  }

  /// Clear saved login credentials
  static Future<bool> clearLoginCredentials() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_savedMobileKey);
      await prefs.remove(_savedPasswordKey);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Save user data after successful login
  static Future<bool> saveUserData(LoginData userData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userDataJson = jsonEncode(userData.toJson());
      await prefs.setString(_userDataKey, userDataJson);
      await prefs.setBool(_isLoggedInKey, true);
      
      // Update notifier
      userNotifier.value = userData;
      
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get saved user data
  static Future<LoginData?> getUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userDataJson = prefs.getString(_userDataKey);
      if (userDataJson != null) {
        final userDataMap = jsonDecode(userDataJson) as Map<String, dynamic>;
        final userData = LoginData.fromJson(userDataMap);
        
        // Update notifier if it's null (first load)
        if (userNotifier.value == null) {
          userNotifier.value = userData;
        }
        
        return userData;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Check if user is logged in
  static Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_isLoggedInKey) ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Clear all user data (logout)
  static Future<bool> clearUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userDataKey);
      await prefs.setBool(_isLoggedInKey, false);
      
      // Clear notifier
      userNotifier.value = null;
      
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Clear all data including credentials
  static Future<bool> clearAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userDataKey);
      await prefs.remove(_isLoggedInKey);
      await prefs.remove(_rememberMeKey);
      await prefs.remove(_savedMobileKey);
      await prefs.remove(_savedPasswordKey);
      
      // Clear notifier
      userNotifier.value = null;
      
      return true;
    } catch (e) {
      return false;
    }
  }
}


