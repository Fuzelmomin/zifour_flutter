import '../api_models/mentor_category_model.dart';

/// Global service to store and access mentor category list across the app
class MentorCategoryService {
  static final MentorCategoryService _instance = MentorCategoryService._internal();
  factory MentorCategoryService() => _instance;
  MentorCategoryService._internal();

  List<MentorCategoryModel> _mentorCategories = [];

  /// Get the current mentor category list
  List<MentorCategoryModel> get mentorCategories => List.unmodifiable(_mentorCategories);

  /// Check if mentor categories are loaded
  bool get hasCategories => _mentorCategories.isNotEmpty;

  /// Get mentor category by ID
  MentorCategoryModel? getCategoryById(String mcatId) {
    try {
      return _mentorCategories.firstWhere((category) => category.mcatId == mcatId);
    } catch (e) {
      return null;
    }
  }

  /// Get mentor category by name
  MentorCategoryModel? getCategoryByName(String name) {
    try {
      return _mentorCategories.firstWhere((category) => category.name == name);
    } catch (e) {
      return null;
    }
  }

  /// Update the mentor category list
  void updateCategories(List<MentorCategoryModel> categories) {
    _mentorCategories = List.from(categories);
  }

  /// Clear the mentor category list
  void clearCategories() {
    _mentorCategories = [];
  }
}
