class RevisionResponse {
  final bool status;
  final String message;
  final RevisionUserData? data;
  final List<PlannerModel> plannerList;

  RevisionResponse({
    required this.status,
    required this.message,
    this.data,
    required this.plannerList,
  });

  factory RevisionResponse.fromJson(Map<String, dynamic> json) {
    return RevisionResponse(
      status: json['status'] == true,
      message: json['message']?.toString() ?? '',
      data: json['data'] != null ? RevisionUserData.fromJson(json['data']) : null,
      plannerList: (json['planner_list'] as List<dynamic>? ?? [])
          .map((item) => PlannerModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class RevisionUserData {
  final String stuId;
  final String stuImage;
  final String stuName;
  final String stuMobile;

  RevisionUserData({
    required this.stuId,
    required this.stuImage,
    required this.stuName,
    required this.stuMobile,
  });

  factory RevisionUserData.fromJson(Map<String, dynamic> json) {
    return RevisionUserData(
      stuId: json['stu_id']?.toString() ?? '',
      stuImage: json['stu_image']?.toString() ?? '',
      stuName: json['stu_name']?.toString() ?? '',
      stuMobile: json['stu_mobile']?.toString() ?? '',
    );
  }
}

class PlannerModel {
  final String plnrId;
  final String plnrMessage;
  final String plnrSdate;
  final String plnrEdate;
  final String standard;
  final String medium;
  final String exam;
  final String subject;
  final String chapter;
  final String topic;

  PlannerModel({
    required this.plnrId,
    required this.plnrMessage,
    required this.plnrSdate,
    required this.plnrEdate,
    required this.standard,
    required this.medium,
    required this.exam,
    required this.subject,
    required this.chapter,
    required this.topic,
  });

  factory PlannerModel.fromJson(Map<String, dynamic> json) {
    return PlannerModel(
      plnrId: json['plnr_id']?.toString() ?? '',
      plnrMessage: json['plnr_message']?.toString() ?? '',
      plnrSdate: json['plnr_sdate']?.toString() ?? '',
      plnrEdate: json['plnr_edate']?.toString() ?? '',
      standard: json['standard']?.toString() ?? '',
      medium: json['medium']?.toString() ?? '',
      exam: json['exam']?.toString() ?? '',
      subject: json['subject']?.toString() ?? '',
      chapter: json['chapter']?.toString() ?? '',
      topic: json['topic']?.toString() ?? '',
    );
  }
}
