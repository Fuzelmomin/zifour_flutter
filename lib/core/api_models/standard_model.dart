import 'package:json_annotation/json_annotation.dart';

part 'standard_model.g.dart';

@JsonSerializable()
class StandardResponse {
  final bool status;
  final String message;
  @JsonKey(name: 'standard_list')
  final List<StandardModel> standardList;

  StandardResponse({
    required this.status,
    required this.message,
    required this.standardList,
  });

  factory StandardResponse.fromJson(Map<String, dynamic> json) =>
      _$StandardResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StandardResponseToJson(this);
}

@JsonSerializable()
class StandardModel {
  @JsonKey(name: 'std_id')
  final String stdId;
  final String name;

  StandardModel({
    required this.stdId,
    required this.name,
  });

  factory StandardModel.fromJson(Map<String, dynamic> json) =>
      _$StandardModelFromJson(json);

  Map<String, dynamic> toJson() => _$StandardModelToJson(this);
}

