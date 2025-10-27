import 'package:json_annotation/json_annotation.dart';

part 'trending_course_model.g.dart';

@JsonSerializable()
class TrendingCourseModel {
  final int id;
  final String title;
  final String imageUrl;
  final double rating;
  final int studentsCount;
  final String? instructor;
  final double? price;

  TrendingCourseModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.rating,
    required this.studentsCount,
    this.instructor,
    this.price,
  });

  factory TrendingCourseModel.fromJson(Map<String, dynamic> json) =>
      _$TrendingCourseModelFromJson(json);

  Map<String, dynamic> toJson() => _$TrendingCourseModelToJson(this);
}

