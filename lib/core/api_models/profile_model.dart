import 'package:json_annotation/json_annotation.dart';
import 'standard_model.dart';
import 'exam_model.dart';
import 'medium_model.dart';
import 'login_model.dart';

part 'profile_model.g.dart';

@JsonSerializable()
class ProfileData {
  @JsonKey(name: 'stu_id', defaultValue: '')
  final String stuId;
  @JsonKey(name: 'stu_image')
  final String? stuImage;
  @JsonKey(name: 'stu_since')
  final String? stuSince;
  @JsonKey(name: 'stu_name', defaultValue: '')
  final String stuName;
  @JsonKey(name: 'stu_mobile', defaultValue: '')
  final String stuMobile;
  @JsonKey(name: 'stu_email')
  final String? stuEmail;
  @JsonKey(name: 'stu_gender', defaultValue: 1)
  final int stuGender;
  @JsonKey(name: 'stu_document')
  final String? stuDocument;
  @JsonKey(name: 'stu_city')
  final String? stuCity;
  @JsonKey(name: 'stu_pincode')
  final String? stuPincode;
  @JsonKey(name: 'stu_address')
  final String? stuAddress;
  @JsonKey(name: 'stu_std_id', defaultValue: '')
  final String stuStdId;
  @JsonKey(name: 'stu_exm_id', defaultValue: '')
  final String stuExmId;
  @JsonKey(name: 'stu_med_id', defaultValue: '0')
  final String stuMedId;

  ProfileData({
    required this.stuId,
    this.stuImage,
    this.stuSince,
    required this.stuName,
    required this.stuMobile,
    this.stuEmail,
    required this.stuGender,
    this.stuDocument,
    this.stuCity,
    this.stuPincode,
    this.stuAddress,
    required this.stuStdId,
    required this.stuExmId,
    required this.stuMedId,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      stuId: json['stu_id']?.toString() ?? '',
      stuImage: json['stu_image']?.toString(),
      stuSince: json['stu_since']?.toString(),
      stuName: json['stu_name']?.toString() ?? '',
      stuMobile: json['stu_mobile']?.toString() ?? '',
      stuEmail: json['stu_email']?.toString(),
      stuGender: (json['stu_gender'] as num?)?.toInt() ?? 1,
      stuDocument: json['stu_document']?.toString(),
      stuCity: json['stu_city']?.toString(),
      stuPincode: json['stu_pincode']?.toString(),
      stuAddress: json['stu_address']?.toString(),
      stuStdId: json['stu_std_id']?.toString() ?? '',
      stuExmId: json['stu_exm_id']?.toString() ?? '',
      stuMedId: json['stu_med_id']?.toString() ?? '0',
    );
  }

  Map<String, dynamic> toJson() => _$ProfileDataToJson(this);
}

@JsonSerializable()
class ProfileResponse {
  final bool status;
  final String message;
  final ProfileData? data;
  @JsonKey(name: 'standard_list')
  final List<NewStandardModel>? standardList;
  @JsonKey(name: 'exam_list')
  final List<NewExamModel>? examList;
  @JsonKey(name: 'medium_list')
  final List<NewMediumModel>? mediumList;

  ProfileResponse({
    required this.status,
    required this.message,
    this.data,
    this.standardList,
    this.examList,
    this.mediumList,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      status: json['status'] as bool? ?? false,
      message: json['message']?.toString() ?? '',
      data: json['data'] != null 
          ? ProfileData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      standardList: (json['standard_list'] as List<dynamic>?)
          ?.map((e) => NewStandardModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      examList: (json['exam_list'] as List<dynamic>?)
          ?.map((e) => NewExamModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      mediumList: (json['medium_list'] is List)
          ? (json['medium_list'] as List)
          .where((e) => e is Map<String, dynamic>) // filter out null or wrong value
          .map((e) => NewMediumModel.fromJson(e))
          .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() => _$ProfileResponseToJson(this);
}

@JsonSerializable()
class UpdateProfileResponse {
  final bool status;
  final String message;
  final LoginData? data;

  UpdateProfileResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory UpdateProfileResponse.fromJson(Map<String, dynamic> json) {
    return UpdateProfileResponse(
      status: json['status'] as bool? ?? false,
      message: json['message']?.toString() ?? '',
      data: json['data'] != null 
          ? LoginData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => _$UpdateProfileResponseToJson(this);
}

@JsonSerializable()
class NewMediumModel {
  @JsonKey(name: 'med_id')
  final String medId;
  @JsonKey(name: 'med_name')
  final String medName;

  NewMediumModel({
    required this.medId,
    required this.medName,
  });

  factory NewMediumModel.fromJson(Map<String, dynamic> json) {
    return NewMediumModel(
      medId: json['med_id'],
      medName: json['med_name']?.toString() ?? '',
    );
  }


  Map<String, dynamic> toJson() =>
      <String, dynamic>{
        'med_id': medId,
        'med_name': medName
      };
}

@JsonSerializable()
class NewStandardModel {
  @JsonKey(name: 'std_id')
  final String stdId;
  @JsonKey(name: 'std_name')
  final String name;

  NewStandardModel({
    required this.stdId,
    required this.name,
  });

  factory NewStandardModel.fromJson(Map<String, dynamic> json) {
    return NewStandardModel(
      stdId: json['std_id'],
      name: json['std_name']?.toString() ?? '',
    );
  }


  Map<String, dynamic> toJson() =>
      <String, dynamic>{
        'std_id': stdId,
        'std_name': name
      };
}

@JsonSerializable()
class NewExamModel {
  @JsonKey(name: 'exm_id')
  final String exmId;
  @JsonKey(name: 'exm_name')
  final String name;

  NewExamModel({
    required this.exmId,
    required this.name,
  });

  factory NewExamModel.fromJson(Map<String, dynamic> json) {
    return NewExamModel(
      exmId: json['exm_id'],
      name: json['exm_name']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() =>
      <String, dynamic>{
        'exm_id': exmId,
        'exm_name': name
      };
}

