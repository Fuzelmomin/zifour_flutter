import 'package:json_annotation/json_annotation.dart';

part 'module_list_model.g.dart';

@JsonSerializable()
class ModuleListResponse {
  final bool status;
  final String message;
  @JsonKey(name: 'modules_list')
  final List<ModuleModel> modulesList;

  ModuleListResponse({
    required this.status,
    required this.message,
    required this.modulesList,
  });

  factory ModuleListResponse.fromJson(Map<String, dynamic> json) =>
      _$ModuleListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ModuleListResponseToJson(this);
}

@JsonSerializable()
class ModuleModel {
  @JsonKey(name: 'mdl_id')
  final String mdlId;
  final String chapter;
  final String name;
  @JsonKey(name: 'pdf_file')
  final String pdfFile;
  final String author;
  final String label;

  ModuleModel({
    required this.mdlId,
    required this.chapter,
    required this.name,
    required this.pdfFile,
    required this.author,
    required this.label,
  });

  factory ModuleModel.fromJson(Map<String, dynamic> json) =>
      _$ModuleModelFromJson(json);

  Map<String, dynamic> toJson() => _$ModuleModelToJson(this);
}
