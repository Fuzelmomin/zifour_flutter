import 'package:json_annotation/json_annotation.dart';

part 'help_support_model.g.dart';

@JsonSerializable()
class HelpSupportResponse {
  final bool status;
  final String message;
  final String whatsapp;
  final String facebook;
  final String instagram;
  final String website;
  @JsonKey(name: 'faq_list')
  final List<FaqModel> faqList;

  HelpSupportResponse({
    required this.status,
    required this.message,
    required this.whatsapp,
    required this.facebook,
    required this.instagram,
    required this.website,
    required this.faqList,
  });

  factory HelpSupportResponse.fromJson(Map<String, dynamic> json) =>
      _$HelpSupportResponseFromJson(json);

  Map<String, dynamic> toJson() => _$HelpSupportResponseToJson(this);
}

@JsonSerializable()
class FaqModel {
  @JsonKey(name: 'fq_id')
  final String fqId;
  final String name;
  @JsonKey(name: 'total_chapter')
  final String? totalChapter;
  @JsonKey(name: 'total_lectures')
  final String? totalLectures;

  FaqModel({
    required this.fqId,
    required this.name,
    this.totalChapter,
    this.totalLectures,
  });

  factory FaqModel.fromJson(Map<String, dynamic> json) =>
      _$FaqModelFromJson(json);

  Map<String, dynamic> toJson() => _$FaqModelToJson(this);
}
