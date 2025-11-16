// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medium_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MediumResponse _$MediumResponseFromJson(Map<String, dynamic> json) =>
    MediumResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
      mediumList: (json['medium_list'] as List<dynamic>)
          .map((e) => MediumModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MediumResponseToJson(MediumResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'medium_list': instance.mediumList,
    };

MediumModel _$MediumModelFromJson(Map<String, dynamic> json) => MediumModel(
      medId: json['med_id'] as String,
      name: json['name'] as String,
      shortName: json['short_name'] as String,
    );

Map<String, dynamic> _$MediumModelToJson(MediumModel instance) =>
    <String, dynamic>{
      'med_id': instance.medId,
      'name': instance.name,
      'short_name': instance.shortName,
    };
