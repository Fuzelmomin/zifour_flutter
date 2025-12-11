// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doubts_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DoubtsListResponse _$DoubtsListResponseFromJson(Map<String, dynamic> json) =>
    DoubtsListResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
      data: json['data'] == null
          ? null
          : StudentData.fromJson(json['data'] as Map<String, dynamic>),
      doubtsList: (json['doubts_list'] as List<dynamic>)
          .map((e) => DoubtModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DoubtsListResponseToJson(DoubtsListResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
      'doubts_list': instance.doubtsList,
    };

StudentData _$StudentDataFromJson(Map<String, dynamic> json) => StudentData(
      stuId: json['stu_id'] as String,
      stuImage: json['stu_image'] as String?,
      stuName: json['stu_name'] as String,
      stuMobile: json['stu_mobile'] as String,
    );

Map<String, dynamic> _$StudentDataToJson(StudentData instance) =>
    <String, dynamic>{
      'stu_id': instance.stuId,
      'stu_image': instance.stuImage,
      'stu_name': instance.stuName,
      'stu_mobile': instance.stuMobile,
    };

DoubtModel _$DoubtModelFromJson(Map<String, dynamic> json) => DoubtModel(
      dbtId: json['dbt_id'] as String,
      isOwner: json['is_owner'] as bool,
      dbtMessage: json['dbt_message'] as String,
      dbtTime: json['dbt_time'] as String,
      dbtDate: json['dbt_date'] as String,
      dbtAttachment: json['dbt_attachment'] as String?,
      standard: json['standard'] as String,
      medium: json['medium'] as String,
      exam: json['exam'] as String,
      subject: json['subject'] as String,
      dbtStatus: json['dbt_status'] as String,
    );

Map<String, dynamic> _$DoubtModelToJson(DoubtModel instance) =>
    <String, dynamic>{
      'dbt_id': instance.dbtId,
      'is_owner': instance.isOwner,
      'dbt_message': instance.dbtMessage,
      'dbt_time': instance.dbtTime,
      'dbt_date': instance.dbtDate,
      'dbt_attachment': instance.dbtAttachment,
      'standard': instance.standard,
      'medium': instance.medium,
      'exam': instance.exam,
      'subject': instance.subject,
      'dbt_status': instance.dbtStatus,
    };
