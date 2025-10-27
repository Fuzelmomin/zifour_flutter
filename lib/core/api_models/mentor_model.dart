import 'package:json_annotation/json_annotation.dart';

part 'mentor_model.g.dart';

@JsonSerializable()
class MentorModel {
  final int id;
  final String name;
  final String profileImageUrl;
  final String designation;
  final double rating;
  final int studentsCount;
  final List<String>? expertise;
  final String? bio;

  MentorModel({
    required this.id,
    required this.name,
    required this.profileImageUrl,
    required this.designation,
    required this.rating,
    required this.studentsCount,
    this.expertise,
    this.bio,
  });

  factory MentorModel.fromJson(Map<String, dynamic> json) =>
      _$MentorModelFromJson(json);

  Map<String, dynamic> toJson() => _$MentorModelToJson(this);
}

