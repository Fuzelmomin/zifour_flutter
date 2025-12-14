class ChangeCourseResponse {
  ChangeCourseResponse({
    required this.isActive,
    required this.message,
    this.data,
  });

  final bool isActive;
  final String message;
  final ChangeCourseData? data;

  factory ChangeCourseResponse.fromJson(Map<String, dynamic> json) {
    return ChangeCourseResponse(
      isActive: json['is_active'] as bool? ?? false,
      message: json['message']?.toString() ?? '',
      data: json['data'] != null
          ? ChangeCourseData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'is_active': isActive,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class ChangeCourseData {
  final String? stuId;
  final String? stuStdId;
  final String? stuMedId;
  final String? stuExmId;
  final String? stuSubId;

  ChangeCourseData({
    this.stuId,
    this.stuStdId,
    this.stuMedId,
    this.stuExmId,
    this.stuSubId,
  });

  factory ChangeCourseData.fromJson(Map<String, dynamic> json) {
    return ChangeCourseData(
      stuId: json['stu_id']?.toString(),
      stuStdId: json['stu_std_id']?.toString(),
      stuMedId: json['stu_med_id']?.toString(),
      stuExmId: json['stu_exm_id']?.toString(),
      stuSubId: json['stu_sub_id']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stu_id': stuId,
      'stu_std_id': stuStdId,
      'stu_med_id': stuMedId,
      'stu_exm_id': stuExmId,
      'stu_sub_id': stuSubId,
    };
  }
}

