import 'package:json_annotation/json_annotation.dart';

part 'mcq_bookmark_delete_model.g.dart';

@JsonSerializable()
class McqBookmarkDeleteResponse {
  final bool status;
  final String message;
  @JsonKey(name: 'mcq_list')
  final List<McqBookmarkDeleteItem> mcqList;

  McqBookmarkDeleteResponse({
    required this.status,
    required this.message,
    required this.mcqList,
  });

  factory McqBookmarkDeleteResponse.fromJson(Map<String, dynamic> json) =>
      _$McqBookmarkDeleteResponseFromJson(json);

  Map<String, dynamic> toJson() => _$McqBookmarkDeleteResponseToJson(this);
}

@JsonSerializable()
class McqBookmarkDeleteItem {
  @JsonKey(name: 'stu_id')
  final String stuId;
  @JsonKey(name: 'mcq_id')
  final String mcqId;

  McqBookmarkDeleteItem({
    required this.stuId,
    required this.mcqId,
  });

  factory McqBookmarkDeleteItem.fromJson(Map<String, dynamic> json) =>
      _$McqBookmarkDeleteItemFromJson(json);

  Map<String, dynamic> toJson() => _$McqBookmarkDeleteItemToJson(this);
}

