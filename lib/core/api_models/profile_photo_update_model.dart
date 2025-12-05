import 'package:json_annotation/json_annotation.dart';

part 'profile_photo_update_model.g.dart';

@JsonSerializable()
class ProfilePhotoUpdateResponse {
  final bool status;
  final String message;
  @JsonKey(name: 'stu_image')
  final String? stuImage;

  ProfilePhotoUpdateResponse({
    required this.status,
    required this.message,
    this.stuImage,
  });

  factory ProfilePhotoUpdateResponse.fromJson(Map<String, dynamic> json) =>
      _$ProfilePhotoUpdateResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProfilePhotoUpdateResponseToJson(this);
}

