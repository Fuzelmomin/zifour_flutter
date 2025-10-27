// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trending_course_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrendingCourseModel _$TrendingCourseModelFromJson(Map<String, dynamic> json) =>
    TrendingCourseModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      imageUrl: json['imageUrl'] as String,
      rating: (json['rating'] as num).toDouble(),
      studentsCount: (json['studentsCount'] as num).toInt(),
      instructor: json['instructor'] as String?,
      price: (json['price'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$TrendingCourseModelToJson(
        TrendingCourseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'imageUrl': instance.imageUrl,
      'rating': instance.rating,
      'studentsCount': instance.studentsCount,
      'instructor': instance.instructor,
      'price': instance.price,
    };
