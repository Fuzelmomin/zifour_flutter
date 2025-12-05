// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challenge_mcq_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChallengeMcqListResponse _$ChallengeMcqListResponseFromJson(
        Map<String, dynamic> json) =>
    ChallengeMcqListResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
      mcqList: (json['mcq_list'] as List<dynamic>)
          .map((e) => McqItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ChallengeMcqListResponseToJson(
        ChallengeMcqListResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'mcq_list': instance.mcqList,
    };

McqItem _$McqItemFromJson(Map<String, dynamic> json) => McqItem(
      mcId: json['mc_id'] as String,
      mcQuestion: json['mc_question'] as String,
      mcDescription: json['mc_description'] as String,
      mcOption1: json['mc_option1'] as String,
      mcOption2: json['mc_option2'] as String,
      mcOption3: json['mc_option3'] as String,
      mcOption4: json['mc_option4'] as String,
      mcAnswer: json['mc_answer'] as String,
      mcSolution: json['mc_solution'] as String,
    );

Map<String, dynamic> _$McqItemToJson(McqItem instance) => <String, dynamic>{
      'mc_id': instance.mcId,
      'mc_question': instance.mcQuestion,
      'mc_description': instance.mcDescription,
      'mc_option1': instance.mcOption1,
      'mc_option2': instance.mcOption2,
      'mc_option3': instance.mcOption3,
      'mc_option4': instance.mcOption4,
      'mc_answer': instance.mcAnswer,
      'mc_solution': instance.mcSolution,
    };
