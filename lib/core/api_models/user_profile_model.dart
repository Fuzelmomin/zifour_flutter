import 'package:json_annotation/json_annotation.dart';

part 'user_profile_model.g.dart';

@JsonSerializable()
class UserProfileModel {
  final int id;
  final String name;
  final String email;
  final String profileImageUrl;
  final String? phone;
  final String? bio;

  UserProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.profileImageUrl,
    this.phone,
    this.bio,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileModelToJson(this);
}

