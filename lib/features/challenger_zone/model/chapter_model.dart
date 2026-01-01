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
  @JsonKey(name: 'sub_id')
  final String? subId;

  ChapterModel({
    required this.chpId,
    required this.name,
    required this.standard,
    required this.medium,
    required this.exam,
    this.subId,
  });

  ChapterModel copyWith({
    String? chpId,
    String? name,
    String? standard,
    String? medium,
    String? exam,
    String? subId,
  }) {
    return ChapterModel(
      chpId: chpId ?? this.chpId,
      name: name ?? this.name,
      standard: standard ?? this.standard,
      medium: medium ?? this.medium,
      exam: exam ?? this.exam,
      subId: subId ?? this.subId,
    );
  }

  factory ChapterModel.fromJson(Map<String, dynamic> json) =>
      _$ChapterModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChapterModelToJson(this);
}

