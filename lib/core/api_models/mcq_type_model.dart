import 'package:json_annotation/json_annotation.dart';

part 'mcq_type_model.g.dart';

@JsonSerializable()
class McqTypeResponse {
  final bool status;
  final String message;
  @JsonKey(name: 'mcq_typ_list')
  final List<McqTypeModel> mcqTypList;

  McqTypeResponse({
    required this.status,
    required this.message,
    required this.mcqTypList,
  });

  factory McqTypeResponse.fromJson(Map<String, dynamic> json) =>
      _$McqTypeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$McqTypeResponseToJson(this);
}

@JsonSerializable()
class McqTypeModel {
  @JsonKey(name: 'mcq_typ_id')
  final String mcqTypId;
  final String name;

  McqTypeModel({
    required this.mcqTypId,
    required this.name,
  });

  factory McqTypeModel.fromJson(Map<String, dynamic> json) =>
      _$McqTypeModelFromJson(json);

  Map<String, dynamic> toJson() => _$McqTypeModelToJson(this);
}
