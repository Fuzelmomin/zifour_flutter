import 'package:json_annotation/json_annotation.dart';

part 'mentor_category_model.g.dart';

@JsonSerializable()
class MentorCategoryResponse {
  final bool status;
  final String message;
  @JsonKey(name: 'mentor_category_list')
  final List<MentorCategoryModel> mentorCategoryList;

  MentorCategoryResponse({
    required this.status,
    required this.message,
    required this.mentorCategoryList,
  });

  factory MentorCategoryResponse.fromJson(Map<String, dynamic> json) =>
      _$MentorCategoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MentorCategoryResponseToJson(this);
}

@JsonSerializable()
class MentorCategoryModel {
  @JsonKey(name: 'mcat_id')
  final String mcatId;
  final String name;

  MentorCategoryModel({
    required this.mcatId,
    required this.name,
  });

  factory MentorCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$MentorCategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$MentorCategoryModelToJson(this);
}
