import 'package:json_annotation/json_annotation.dart';

part 'mcq_notes_delete_model.g.dart';

@JsonSerializable()
class McqNotesDeleteResponse {
  final bool status;
  final String message;
  @JsonKey(name: 'mcq_list')
  final List<McqNotesDeleteItem> mcqList;

  McqNotesDeleteResponse({
    required this.status,
    required this.message,
    required this.mcqList,
  });

  factory McqNotesDeleteResponse.fromJson(Map<String, dynamic> json) =>
      _$McqNotesDeleteResponseFromJson(json);

  Map<String, dynamic> toJson() => _$McqNotesDeleteResponseToJson(this);
}

@JsonSerializable()
class McqNotesDeleteItem {
  @JsonKey(name: 'stu_id')
  final String stuId;
  @JsonKey(name: 'mcq_id')
  final String mcqId;

  McqNotesDeleteItem({
    required this.stuId,
    required this.mcqId,
  });

  factory McqNotesDeleteItem.fromJson(Map<String, dynamic> json) =>
      _$McqNotesDeleteItemFromJson(json);

  Map<String, dynamic> toJson() => _$McqNotesDeleteItemToJson(this);
}

