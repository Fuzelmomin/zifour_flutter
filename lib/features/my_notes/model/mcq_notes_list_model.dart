import 'package:json_annotation/json_annotation.dart';

part 'mcq_notes_list_model.g.dart';

@JsonSerializable()
class McqNotesListResponse {
  final bool status;
  final String message;
  @JsonKey(name: 'mcq_notes_list')
  final List<McqNotesListItem> mcqNotesList;

  McqNotesListResponse({
    required this.status,
    required this.message,
    required this.mcqNotesList,
  });

  factory McqNotesListResponse.fromJson(Map<String, dynamic> json) =>
      _$McqNotesListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$McqNotesListResponseToJson(this);
}

@JsonSerializable()
class McqNotesListItem {
  @JsonKey(name: 'mcq_nts_id')
  final String mcqNtsId;
  @JsonKey(name: 'mcq_id')
  final String mcqId;
  @JsonKey(name: 'mc_question')
  final String mcQuestion;
  @JsonKey(name: 'mc_description')
  final String mcDescription;

  McqNotesListItem({
    required this.mcqNtsId,
    required this.mcqId,
    required this.mcQuestion,
    required this.mcDescription,
  });

  factory McqNotesListItem.fromJson(Map<String, dynamic> json) =>
      _$McqNotesListItemFromJson(json);

  Map<String, dynamic> toJson() => _$McqNotesListItemToJson(this);
}

