// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mcq_type_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

McqTypeResponse _$McqTypeResponseFromJson(Map<String, dynamic> json) =>
    McqTypeResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
      mcqTypList: (json['mcq_typ_list'] as List<dynamic>)
          .map((e) => McqTypeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$McqTypeResponseToJson(McqTypeResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'mcq_typ_list': instance.mcqTypList,
    };

McqTypeModel _$McqTypeModelFromJson(Map<String, dynamic> json) => McqTypeModel(
      mcqTypId: json['mcq_typ_id'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$McqTypeModelToJson(McqTypeModel instance) =>
    <String, dynamic>{
      'mcq_typ_id': instance.mcqTypId,
      'name': instance.name,
    };
