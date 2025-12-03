import 'package:json_annotation/json_annotation.dart';

part 'chapter_model.g.dart';

@JsonSerializable()
class ChapterResponse {
  final bool status;
  final String message;
  @JsonKey(name: 'chapter_list')
  final List<ChapterModel> chapterList;

  ChapterResponse({
    required this.status,
    required this.message,
    required this.chapterList,
  });

  factory ChapterResponse.fromJson(Map<String, dynamic> json) =>
      _$ChapterResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ChapterResponseToJson(this);
}

@JsonSerializable()
class ChapterModel {
  @JsonKey(name: 'chp_id')
  final String chpId;
  final String name;
  final String standard;
  final String medium;
  final String exam;

  ChapterModel({
    required this.chpId,
    required this.name,
    required this.standard,
    required this.medium,
    required this.exam,
  });

  factory ChapterModel.fromJson(Map<String, dynamic> json) =>
      _$ChapterModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChapterModelToJson(this);
}

