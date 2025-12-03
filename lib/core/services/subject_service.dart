import '../api_models/subject_model.dart';

/// Global service to store and access subject list across the app
class SubjectService {
  static final SubjectService _instance = SubjectService._internal();
  factory SubjectService() => _instance;
  SubjectService._internal();

  List<SubjectModel> _subjects = [];

  /// Get the current subject list
  List<SubjectModel> get subjects => List.unmodifiable(_subjects);

  /// Check if subjects are loaded
  bool get hasSubjects => _subjects.isNotEmpty;

  /// Get subject by ID
  SubjectModel? getSubjectById(String subId) {
    try {
      return _subjects.firstWhere((subject) => subject.subId == subId);
    } catch (e) {
      return null;
    }
  }

  /// Get subject by name
  SubjectModel? getSubjectByName(String name) {
    try {
      return _subjects.firstWhere((subject) => subject.name == name);
    } catch (e) {
      return null;
    }
  }

  /// Update the subject list
  void updateSubjects(List<SubjectModel> subjects) {
    _subjects = List.from(subjects);
  }

  /// Clear the subject list
  void clearSubjects() {
    _subjects = [];
  }
}

