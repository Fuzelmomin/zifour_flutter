// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'module_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModuleListResponse _$ModuleListResponseFromJson(Map<String, dynamic> json) =>
    ModuleListResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
      modulesList: (json['modules_list'] as List<dynamic>)
          .map((e) => ModuleModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ModuleListResponseToJson(ModuleListResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'modules_list': instance.modulesList,
    };

ModuleModel _$ModuleModelFromJson(Map<String, dynamic> json) => ModuleModel(
      mdlId: json['mdl_id'] as String,
      chapter: json['chapter'] as String,
      name: json['name'] as String,
      pdfFile: json['pdf_file'] as String,
      author: json['author'] as String,
      label: json['label'] as String,
    );

Map<String, dynamic> _$ModuleModelToJson(ModuleModel instance) =>
    <String, dynamic>{
      'mdl_id': instance.mdlId,
      'chapter': instance.chapter,
      'name': instance.name,
      'pdf_file': instance.pdfFile,
      'author': instance.author,
      'label': instance.label,
    };
