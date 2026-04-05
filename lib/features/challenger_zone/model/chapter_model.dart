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
  @JsonKey(name: 'chp_pdf')
  final String? chpPdf;
  @JsonKey(name: 'chp_tot_mcq')
  final int? chpTotMcq;
  @JsonKey(name: 'chp_tot_lectures')
  final int? chpTotLectures;
  @JsonKey(name: 'chp_tot_test')
  final int? chpTotTest;

  ChapterModel({
    required this.chpId,
    required this.name,
    required this.standard,
    required this.medium,
    required this.exam,
    this.subId,
    this.chpPdf,
    this.chpTotMcq,
    this.chpTotLectures,
    this.chpTotTest,
  });

  ChapterModel copyWith({
    String? chpId,
    String? name,
    String? standard,
    String? medium,
    String? exam,
    String? subId,
    String? chpPdf,
    int? chpTotMcq,
    int? chpTotLectures,
    int? chpTotTest,
  }) {
    return ChapterModel(
      chpId: chpId ?? this.chpId,
      name: name ?? this.name,
      standard: standard ?? this.standard,
      medium: medium ?? this.medium,
      exam: exam ?? this.exam,
      subId: subId ?? this.subId,
      chpPdf: chpPdf ?? this.chpPdf,
      chpTotMcq: chpTotMcq ?? this.chpTotMcq,
      chpTotLectures: chpTotLectures ?? this.chpTotLectures,
      chpTotTest: chpTotTest ?? this.chpTotTest,
    );
  }

  factory ChapterModel.fromJson(Map<String, dynamic> json) =>
      _$ChapterModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChapterModelToJson(this);
}

