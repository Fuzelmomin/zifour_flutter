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
  });

  factory ChallengeResultResponse.fromJson(Map<String, dynamic> json) =>
      _$ChallengeResultResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ChallengeResultResponseToJson(this);
}
