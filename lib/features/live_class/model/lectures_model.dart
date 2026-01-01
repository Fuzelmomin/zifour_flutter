class LecturesResponse {
  LecturesResponse({
    required this.status,
    required this.message,
    this.chpTitle,
    this.testBtn,
    this.lectureList,
  });

  final bool status;
  final String message;
  final String? chpTitle;
  final int? testBtn;
  final List<LectureItem>? lectureList;

  factory LecturesResponse.fromJson(Map<String, dynamic> json) {
    return LecturesResponse(
      status: json['status'] as bool? ?? false,
      message: json['message']?.toString() ?? '',
      chpTitle: json['chp_title']?.toString(),
      testBtn: json['test_btn'] as int?,
      lectureList: json['lecture_list'] != null
          ? (json['lecture_list'] as List)
              .map((item) =>
                  LectureItem.fromJson(item as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'chp_title': chpTitle,
      'test_btn': testBtn,
      'lecture_list': lectureList?.map((item) => item.toJson()).toList(),
    };
  }
}

class LectureItem {
  LectureItem({
    this.lecId,
    this.chpName,
    this.name,
    this.standard,
    this.medium,
    this.subject,
    this.exam,
    this.youtubeVideo,
    this.videoLength,
    this.viewAt,
    this.lecTime,
    this.lecDate,
    this.teacherName,
    this.lecStart,
    this.remeberFlag,
  });

  final String? lecId;
  final String? chpName;
  final String? name;
  final String? standard;
  final String? medium;
  final String? subject;
  final String? exam;
  final String? youtubeVideo;
  final String? videoLength;
  final String? viewAt;
  final String? lecTime;
  final String? lecDate;
  final String? teacherName;
  final String? lecStart;
  final String? remeberFlag;

  LectureItem copyWith({
    String? lecId,
    String? chpName,
    String? name,
    String? standard,
    String? medium,
    String? subject,
    String? exam,
    String? youtubeVideo,
    String? videoLength,
    String? viewAt,
    String? lecTime,
    String? lecDate,
    String? teacherName,
    String? lecStart,
    String? remeberFlag,
  }) {
    return LectureItem(
      lecId: lecId ?? this.lecId,
      chpName: chpName ?? this.chpName,
      name: name ?? this.name,
      standard: standard ?? this.standard,
      medium: medium ?? this.medium,
      subject: subject ?? this.subject,
      exam: exam ?? this.exam,
      youtubeVideo: youtubeVideo ?? this.youtubeVideo,
      videoLength: videoLength ?? this.videoLength,
      viewAt: viewAt ?? this.viewAt,
      lecTime: lecTime ?? this.lecTime,
      lecDate: lecDate ?? this.lecDate,
      teacherName: teacherName ?? this.teacherName,
      lecStart: lecStart ?? this.lecStart,
      remeberFlag: remeberFlag ?? this.remeberFlag,
    );
  }

  factory LectureItem.fromJson(Map<String, dynamic> json) {
    return LectureItem(
      lecId: json['lec_id']?.toString(),
      chpName: json['chp_name']?.toString(),
      name: json['name']?.toString(),
      standard: json['standard']?.toString(),
      medium: json['medium']?.toString(),
      subject: json['subject']?.toString(),
      exam: json['exam']?.toString(),
      youtubeVideo: json['youtube_video']?.toString(),
      videoLength: json['video_length']?.toString(),
      viewAt: json['view_at']?.toString(),
      lecTime: json['lec_time']?.toString(),
      lecDate: json['lec_date']?.toString(),
      teacherName: json['teacher_name']?.toString(),
      lecStart: json['lec_start']?.toString(),
      remeberFlag: json['remeber_flag']?.toString(),
     //lecStart: "2025-12-31 00:01:00",
    );
  }

  String get thumbnailUrl =>
      'https://img.youtube.com/vi/$youtubeVideo/hqdefault.jpg';

  String get youtubeUrl => 'https://www.youtube.com/watch?v=$youtubeVideo';

  Map<String, dynamic> toJson() {
    return {
      'lec_id': lecId,
      'chp_name': chpName,
      'name': name,
      'standard': standard,
      'medium': medium,
      'subject': subject,
      'exam': exam,
      'youtube_video': youtubeVideo,
      'video_length': videoLength,
      'view_at': viewAt,
      'lec_time': lecTime,
      'lec_date': lecDate,
      'teacher_name': teacherName,
      'lec_start': lecStart,
      'remeber_flag': remeberFlag,
    };
  }
}

