import '../api_models/mcq_type_model.dart';

/// Global service to store and access MCQ type list across the app
class McqTypeService {
  static final McqTypeService _instance = McqTypeService._internal();
  factory McqTypeService() => _instance;
  McqTypeService._internal();

  List<McqTypeModel> _mcqTypes = [];

  /// Get the current MCQ type list
  List<McqTypeModel> get mcqTypes => List.unmodifiable(_mcqTypes);

  /// Check if MCQ types are loaded
  bool get hasMcqTypes => _mcqTypes.isNotEmpty;

  /// Get MCQ type by ID
  McqTypeModel? getMcqTypeById(String mcqTypId) {
    try {
      return _mcqTypes.firstWhere((mcqType) => mcqType.mcqTypId == mcqTypId);
    } catch (e) {
      return null;
    }
  }

  /// Get MCQ type by name
  McqTypeModel? getMcqTypeByName(String name) {
    try {
      return _mcqTypes.firstWhere((mcqType) => mcqType.name == name);
    } catch (e) {
      return null;
    }
  }

  /// Update the MCQ type list
  void updateMcqTypes(List<McqTypeModel> mcqTypes) {
    _mcqTypes = List.from(mcqTypes);
  }

  /// Clear the MCQ type list
  void clearMcqTypes() {
    _mcqTypes = [];
  }
}
