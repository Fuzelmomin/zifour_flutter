import 'package:json_annotation/json_annotation.dart';

part 'subject_model.g.dart';

@JsonSerializable()
class SubjectResponse {
  final bool status;
  final String message;
  @JsonKey(name: 'subject_list')
  final List<SubjectModel> subjectList;

  SubjectResponse({
    required this.status,
    required this.message,
    required this.subjectList,
  });

  factory SubjectResponse.fromJson(Map<String, dynamic> json) =>
      _$SubjectResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SubjectResponseToJson(this);
}

@JsonSerializable()
class SubjectModel {
  @JsonKey(name: 'sub_id')
  final String subId;
  final String name;
  final String icon;

  @JsonKey(name: 'total_lectures')
  final String? totalLectures;
  @JsonKey(name: 'total_chapter')
  final String? totalChapter;

  SubjectModel({
    required this.subId,
    required this.name,
    required this.icon,
    this.totalLectures,
    this.totalChapter,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) =>
      _$SubjectModelFromJson(json);

  Map<String, dynamic> toJson() => _$SubjectModelToJson(this);
}

