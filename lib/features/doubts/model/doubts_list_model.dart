import 'package:json_annotation/json_annotation.dart';

part 'doubts_list_model.g.dart';

@JsonSerializable()
class DoubtsListResponse {
  final bool status;
  final String message;
  final StudentData? data;
  @JsonKey(name: 'doubts_list')
  final List<DoubtModel> doubtsList;

  DoubtsListResponse({
    required this.status,
    required this.message,
    this.data,
    required this.doubtsList,
  });

  factory DoubtsListResponse.fromJson(Map<String, dynamic> json) =>
      _$DoubtsListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DoubtsListResponseToJson(this);
}

@JsonSerializable()
class StudentData {
  @JsonKey(name: 'stu_id')
  final String stuId;
  @JsonKey(name: 'stu_image')
  final String? stuImage;
  @JsonKey(name: 'stu_name')
  final String stuName;
  @JsonKey(name: 'stu_mobile')
  final String stuMobile;

  StudentData({
    required this.stuId,
    this.stuImage,
    required this.stuName,
    required this.stuMobile,
  });

  factory StudentData.fromJson(Map<String, dynamic> json) =>
      _$StudentDataFromJson(json);

  Map<String, dynamic> toJson() => _$StudentDataToJson(this);
}

@JsonSerializable()
class DoubtModel {
  @JsonKey(name: 'dbt_id')
  final String dbtId;
  @JsonKey(name: 'is_owner')
  final bool isOwner;
  @JsonKey(name: 'dbt_message')
  final String dbtMessage;
  @JsonKey(name: 'dbt_time')
  final String dbtTime;
  @JsonKey(name: 'dbt_date')
  final String dbtDate;
  @JsonKey(name: 'dbt_attachment')
  final String? dbtAttachment;
  final String standard;
  final String medium;
  final String exam;
  final String subject;
  @JsonKey(name: 'dbt_status')
  final String dbtStatus;

  DoubtModel({
    required this.dbtId,
    required this.isOwner,
    required this.dbtMessage,
    required this.dbtTime,
    required this.dbtDate,
    this.dbtAttachment,
    required this.standard,
    required this.medium,
    required this.exam,
    required this.subject,
    required this.dbtStatus,
  });

  factory DoubtModel.fromJson(Map<String, dynamic> json) =>
      _$DoubtModelFromJson(json);

  Map<String, dynamic> toJson() => _$DoubtModelToJson(this);
}

