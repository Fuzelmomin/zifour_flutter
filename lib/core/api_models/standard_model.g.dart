// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'standard_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StandardResponse _$StandardResponseFromJson(Map<String, dynamic> json) =>
    StandardResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
      standardList: (json['standard_list'] as List<dynamic>)
          .map((e) => StandardModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StandardResponseToJson(StandardResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'standard_list': instance.standardList,
    };

StandardModel _$StandardModelFromJson(Map<String, dynamic> json) =>
    StandardModel(
      stdId: json['std_id'] as String,
      name: json['std_name'] as String,
    );

Map<String, dynamic> _$StandardModelToJson(StandardModel instance) =>
    <String, dynamic>{
      'std_id': instance.stdId,
      'std_name': instance.name,
    };
