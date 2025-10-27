import 'package:json_annotation/json_annotation.dart';

part 'banner_model.g.dart';

@JsonSerializable()
class BannerModel {
  final int id;
  final String imageUrl;
  final String? title;
  final String? subtitle;
  final String? actionUrl;

  BannerModel({
    required this.id,
    required this.imageUrl,
    this.title,
    this.subtitle,
    this.actionUrl,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) =>
      _$BannerModelFromJson(json);

  Map<String, dynamic> toJson() => _$BannerModelToJson(this);
}

