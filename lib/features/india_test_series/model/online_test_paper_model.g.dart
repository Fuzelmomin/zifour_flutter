// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'online_test_paper_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OnlineTestPaperResponse _$OnlineTestPaperResponseFromJson(
        Map<String, dynamic> json) =>
    OnlineTestPaperResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
      generalPaperList: (json['general_paper_list'] as List<dynamic>)
          .map((e) => TestPaperModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OnlineTestPaperResponseToJson(
        OnlineTestPaperResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'general_paper_list': instance.generalPaperList,
    };

TestPaperModel _$TestPaperModelFromJson(Map<String, dynamic> json) =>
    TestPaperModel(
      gPaId: json['g_pa_id'] as String,
      gPaName: json['g_pa_name'] as String,
    );

Map<String, dynamic> _$TestPaperModelToJson(TestPaperModel instance) =>
    <String, dynamic>{
      'g_pa_id': instance.gPaId,
      'g_pa_name': instance.gPaName,
    };
