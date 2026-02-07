import 'package:json_annotation/json_annotation.dart';

part 'submit_mcq_answer_model.g.dart';

@JsonSerializable()
class SubmitMcqAnswerResponse {
  final bool status;
  final String message;
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

  SubmitMcqAnswerResponse({
    required this.status,
    required this.message,
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
  });

  factory SubmitMcqAnswerResponse.fromJson(Map<String, dynamic> json) =>
      _$SubmitMcqAnswerResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SubmitMcqAnswerResponseToJson(this);
}

