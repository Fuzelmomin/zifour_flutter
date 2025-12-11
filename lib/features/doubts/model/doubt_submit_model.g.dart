// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doubt_submit_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DoubtSubmitResponse _$DoubtSubmitResponseFromJson(Map<String, dynamic> json) =>
    DoubtSubmitResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
    );

Map<String, dynamic> _$DoubtSubmitResponseToJson(
        DoubtSubmitResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
    };
