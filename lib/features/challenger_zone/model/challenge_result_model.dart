import 'package:json_annotation/json_annotation.dart';

part 'challenge_result_model.g.dart';

@JsonSerializable()
class ChallengeResultResponse {
  final bool status;
  final String message;
  final String? subject;
  final String? total;
  final String? unattended;
  final String? attended;
  final String? correct;
  final String? wrong;
  final String? marks;
  final String? percentage;

  final String? standard;
  final String? medium;
  final String? exam;
  @JsonKey(name: 'pk_name')
  final String? pkName;

  @JsonKey(name: 'pdf_file')
  final String? pdfFile;

  ChallengeResultResponse({
    required this.status,
    required this.message,
    this.subject,
    this.total,
    this.unattended,
    this.attended,
    this.correct,
    this.wrong,
    this.marks,
    this.percentage,

    this.standard,
    this.medium,
    this.exam,
    this.pkName,
    this.pdfFile,
  });

  factory ChallengeResultResponse.fromJson(Map<String, dynamic> json) =>
      _$ChallengeResultResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ChallengeResultResponseToJson(this);
}
