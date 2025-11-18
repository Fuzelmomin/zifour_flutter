import 'package:json_annotation/json_annotation.dart';

part 'exam_model.g.dart';

@JsonSerializable()
class ExamResponse {
  final bool status;
  final String message;
  @JsonKey(name: 'exam_list')
  final List<ExamModel> examList;

  ExamResponse({
    required this.status,
    required this.message,
    required this.examList,
  });

  factory ExamResponse.fromJson(Map<String, dynamic> json) =>
      _$ExamResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ExamResponseToJson(this);
}

@JsonSerializable()
class ExamModel {
  @JsonKey(name: 'exm_id')
  final String exmId;
  @JsonKey(name: 'exm_name')
  final String name;

  ExamModel({
    required this.exmId,
    required this.name,
  });

  factory ExamModel.fromJson(Map<String, dynamic> json) =>
      _$ExamModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExamModelToJson(this);
}

