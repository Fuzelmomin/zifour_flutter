import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class McqPreference {
  static const String _keyPrefix = 'mcq_progress_';

  static String _getKey(String topicId) => '$_keyPrefix$topicId';

  /// Save progress for a specific topic
  static Future<void> saveProgress({
    required String topicId,
    required int lastIndex,
    required Map<String, String> answers,
    required Map<String, int> times,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final data = {
      'lastIndex': lastIndex,
      'answers': answers,
      'times': times,
    };
    await prefs.setString(_getKey(topicId), jsonEncode(data));
  }

  /// Load progress for a specific topic
  static Future<Map<String, dynamic>?> getProgress(String topicId) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_getKey(topicId));
    if (jsonString == null) return null;

    try {
      final Map<String, dynamic> data = jsonDecode(jsonString);
      return {
        'lastIndex': data['lastIndex'] as int,
        'answers': Map<String, String>.from(data['answers'] ?? {}),
        'times': Map<String, int>.from(data['times'] ?? {}),
      };
    } catch (e) {
      return null;
    }
  }

  /// Clear progress for a specific topic
  static Future<void> clearProgress(String topicId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_getKey(topicId));
  }
}
