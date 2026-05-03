// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submit_mcq_answer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubmitMcqAnswerResponse _$SubmitMcqAnswerResponseFromJson(
        Map<String, dynamic> json) =>
    SubmitMcqAnswerResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
      tpcName: json['tpc_name'] as String?,
      chpName: json['chp_name'] as String?,
      standard: json['standard'] as String?,
      medium: json['medium'] as String?,
      subject: json['subject'] as String?,
      exam: json['exam'] as String?,
      total: json['total'] as String?,
      unattended: json['unattended'] as String?,
      attended: json['attended'] as String?,
      correct: json['correct'] as String?,
      wrong: json['wrong'] as String?,
      marks: json['marks'] as String?,
      percentage: json['percentage'] as String?,
      pdfFile: json['pdf_file'] as String?,
      mcqTypeList: (json['mcq_type_list'] as List<dynamic>?)
          ?.map((e) => McqTypeItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SubmitMcqAnswerResponseToJson(
        SubmitMcqAnswerResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'tpc_name': instance.tpcName,
      'chp_name': instance.chpName,
      'standard': instance.standard,
      'medium': instance.medium,
      'subject': instance.subject,
      'exam': instance.exam,
      'total': instance.total,
      'unattended': instance.unattended,
      'attended': instance.attended,
      'correct': instance.correct,
      'wrong': instance.wrong,
      'marks': instance.marks,
      'percentage': instance.percentage,
      'pdf_file': instance.pdfFile,
      'mcq_type_list': instance.mcqTypeList,
    };

McqTypeItem _$McqTypeItemFromJson(Map<String, dynamic> json) => McqTypeItem(
      typeId: json['type_id'] as String?,
      name: json['name'] as String?,
      accuracy: json['accuracy'] as String?,
    );

Map<String, dynamic> _$McqTypeItemToJson(McqTypeItem instance) =>
    <String, dynamic>{
      'type_id': instance.typeId,
      'name': instance.name,
      'accuracy': instance.accuracy,
    };
