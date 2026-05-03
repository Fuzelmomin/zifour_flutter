import 'package:json_annotation/json_annotation.dart';

part 'submit_mcq_answer_model.g.dart';

@JsonSerializable()
class SubmitMcqAnswerResponse {
  final bool status;
  final String message;

  @JsonKey(name: 'tpc_name')
  final String? tpcName;

  @JsonKey(name: 'chp_name')
  final String? chpName;

  final String? standard;
  final String? medium;
  final String? subject;
  final String? exam;
  String? total;
  final String? unattended;
  final String? attended;
  final String? correct;
  final String? wrong;
  final String? marks;
  final String? percentage;

  @JsonKey(name: 'pdf_file')
  final String? pdfFile;

  @JsonKey(name: 'mcq_type_list')
  final List<McqTypeItem>? mcqTypeList;

  SubmitMcqAnswerResponse({
    required this.status,
    required this.message,
    this.tpcName,
    this.chpName,
    this.standard,
    this.medium,
    this.subject,
    this.exam,
    this.total,
    this.unattended,
    this.attended,
    this.correct,
    this.wrong,
    this.marks,
    this.percentage,
    this.pdfFile,
    this.mcqTypeList,
  });

  factory SubmitMcqAnswerResponse.fromJson(Map<String, dynamic> json) =>
      _$SubmitMcqAnswerResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SubmitMcqAnswerResponseToJson(this);
}

@JsonSerializable()
class McqTypeItem {
  @JsonKey(name: 'type_id')
  final String? typeId;

  final String? name;
  final String? accuracy;

  McqTypeItem({
    this.typeId,
    this.name,
    this.accuracy,
  });

  factory McqTypeItem.fromJson(Map<String, dynamic> json) =>
      _$McqTypeItemFromJson(json);

  Map<String, dynamic> toJson() => _$McqTypeItemToJson(this);
}

