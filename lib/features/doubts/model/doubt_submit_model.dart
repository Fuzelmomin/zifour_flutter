import 'package:json_annotation/json_annotation.dart';

part 'doubt_submit_model.g.dart';

@JsonSerializable()
class DoubtSubmitResponse {
  final bool status;
  final String message;

  DoubtSubmitResponse({
    required this.status,
    required this.message,
  });

  factory DoubtSubmitResponse.fromJson(Map<String, dynamic> json) =>
      _$DoubtSubmitResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DoubtSubmitResponseToJson(this);
}

