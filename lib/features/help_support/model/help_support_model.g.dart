// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'help_support_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HelpSupportResponse _$HelpSupportResponseFromJson(Map<String, dynamic> json) =>
    HelpSupportResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
      whatsapp: json['whatsapp'] as String,
      facebook: json['facebook'] as String,
      instagram: json['instagram'] as String,
      website: json['website'] as String,
      faqList: (json['faq_list'] as List<dynamic>)
          .map((e) => FaqModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$HelpSupportResponseToJson(
        HelpSupportResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'whatsapp': instance.whatsapp,
      'facebook': instance.facebook,
      'instagram': instance.instagram,
      'website': instance.website,
      'faq_list': instance.faqList,
    };

FaqModel _$FaqModelFromJson(Map<String, dynamic> json) => FaqModel(
      fqId: json['fq_id'] as String,
      name: json['name'] as String,
      totalChapter: json['total_chapter'] as String?,
      totalLectures: json['total_lectures'] as String?,
    );

Map<String, dynamic> _$FaqModelToJson(FaqModel instance) => <String, dynamic>{
      'fq_id': instance.fqId,
      'name': instance.name,
      'total_chapter': instance.totalChapter,
      'total_lectures': instance.totalLectures,
    };
