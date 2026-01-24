// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'solution_video_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SolutionVideoResponse _$SolutionVideoResponseFromJson(
        Map<String, dynamic> json) =>
    SolutionVideoResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
      solutionList: (json['genr_solution_list'] as List<dynamic>)
          .map((e) => SolutionVideoModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SolutionVideoResponseToJson(
        SolutionVideoResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'genr_solution_list': instance.solutionList,
    };

SolutionVideoModel _$SolutionVideoModelFromJson(Map<String, dynamic> json) =>
    SolutionVideoModel(
      gSlId: json['g_sl_id'] as String,
      solutionVideo: json['solution_video'] as String,
    );

Map<String, dynamic> _$SolutionVideoModelToJson(SolutionVideoModel instance) =>
    <String, dynamic>{
      'g_sl_id': instance.gSlId,
      'solution_video': instance.solutionVideo,
    };

ExpertSolutionVideoResponse _$ExpertSolutionVideoResponseFromJson(
        Map<String, dynamic> json) =>
    ExpertSolutionVideoResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
      solutionList: (json['exprt_solution_list'] as List<dynamic>)
          .map((e) =>
              ExpertSolutionVideoModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ExpertSolutionVideoResponseToJson(
        ExpertSolutionVideoResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'exprt_solution_list': instance.solutionList,
    };

ExpertSolutionVideoModel _$ExpertSolutionVideoModelFromJson(
        Map<String, dynamic> json) =>
    ExpertSolutionVideoModel(
      crtChSlId: json['crt_ch_sl_id'] as String,
      solutionVideo: json['solution_video'] as String,
    );

Map<String, dynamic> _$ExpertSolutionVideoModelToJson(
        ExpertSolutionVideoModel instance) =>
    <String, dynamic>{
      'crt_ch_sl_id': instance.crtChSlId,
      'solution_video': instance.solutionVideo,
    };
