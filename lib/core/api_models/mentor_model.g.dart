// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mentor_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MentorModel _$MentorModelFromJson(Map<String, dynamic> json) => MentorModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      profileImageUrl: json['profileImageUrl'] as String,
      designation: json['designation'] as String,
      rating: (json['rating'] as num).toDouble(),
      studentsCount: (json['studentsCount'] as num).toInt(),
      expertise: (json['expertise'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      bio: json['bio'] as String?,
    );

Map<String, dynamic> _$MentorModelToJson(MentorModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'profileImageUrl': instance.profileImageUrl,
      'designation': instance.designation,
      'rating': instance.rating,
      'studentsCount': instance.studentsCount,
      'expertise': instance.expertise,
      'bio': instance.bio,
    };
