import 'package:json_annotation/json_annotation.dart';

part 'image_upload_model.g.dart';

@JsonSerializable()
class ImageUploadResponse {
  final bool status;
  final String message;
  final String? imageurl;

  ImageUploadResponse({
    required this.status,
    required this.message,
    this.imageurl,
  });

  factory ImageUploadResponse.fromJson(Map<String, dynamic> json) =>
      _$ImageUploadResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ImageUploadResponseToJson(this);
}

