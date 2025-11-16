import 'package:json_annotation/json_annotation.dart';

part 'medium_model.g.dart';

@JsonSerializable()
class MediumResponse {
  final bool status;
  final String message;
  @JsonKey(name: 'medium_list')
  final List<MediumModel> mediumList;

  MediumResponse({
    required this.status,
    required this.message,
    required this.mediumList,
  });

  factory MediumResponse.fromJson(Map<String, dynamic> json) =>
      _$MediumResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MediumResponseToJson(this);
}

@JsonSerializable()
class MediumModel {
  @JsonKey(name: 'med_id')
  final String medId;
  final String name;
  @JsonKey(name: 'short_name')
  final String shortName;

  MediumModel({
    required this.medId,
    required this.name,
    required this.shortName,
  });

  factory MediumModel.fromJson(Map<String, dynamic> json) =>
      _$MediumModelFromJson(json);

  Map<String, dynamic> toJson() => _$MediumModelToJson(this);
}

