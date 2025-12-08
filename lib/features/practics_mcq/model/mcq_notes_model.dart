import 'package:json_annotation/json_annotation.dart';

part 'mcq_notes_model.g.dart';

@JsonSerializable()
class McqNotesResponse {
  final bool status;
  final String message;
  @JsonKey(name: 'mcq_list')
  final List<McqNotesItem> mcqList;

  McqNotesResponse({
    required this.status,
    required this.message,
    required this.mcqList,
  });

  factory McqNotesResponse.fromJson(Map<String, dynamic> json) =>
      _$McqNotesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$McqNotesResponseToJson(this);
}

@JsonSerializable()
class McqNotesItem {
  @JsonKey(name: 'mcq_nts_id')
  final int mcqNtsId;
  @JsonKey(name: 'stu_id')
  final String stuId;
  @JsonKey(name: 'mcq_id')
  final String mcqId;

  McqNotesItem({
    required this.mcqNtsId,
    required this.stuId,
    required this.mcqId,
  });

  factory McqNotesItem.fromJson(Map<String, dynamic> json) =>
      _$McqNotesItemFromJson(json);

  Map<String, dynamic> toJson() => _$McqNotesItemToJson(this);
}

