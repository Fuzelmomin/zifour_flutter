import '../../courses/models/course_package.dart';

class HomeResponse {
  final bool status;
  final String message;
  final int notificationIcon;
  final int lectureReport;
  final bool isSoftBoxEnabled;
  final List<MentorVideo> mentorVideos;
  final List<HomeSlider> sliders;
  final List<CoursePackage> packages;

  HomeResponse({
    required this.status,
    required this.message,
    required this.notificationIcon,
    required this.lectureReport,
    required this.isSoftBoxEnabled,
    required this.mentorVideos,
    required this.sliders,
    required this.packages,
  });

  factory HomeResponse.fromJson(Map<String, dynamic> json) {
    return HomeResponse(
      status: json['status'] == true,
      message: json['message']?.toString() ?? '',
      notificationIcon: _parseInt(json['ntf_icon']),
      lectureReport: _parseInt(json['lec_rept']),
      isSoftBoxEnabled: json['isSftBoxEnable'] == true,
      mentorVideos: (json['mtvid_list'] as List<dynamic>? ?? [])
          .map((item) => MentorVideo.fromJson(item as Map<String, dynamic>))
          .toList(),
      sliders: (json['slider_list'] as List<dynamic>? ?? [])
          .map((item) => HomeSlider.fromJson(item as Map<String, dynamic>))
          .toList(),
      packages: (json['package_list'] as List<dynamic>? ?? [])
          .map((item) => CoursePackage.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class MentorVideo {
  final String id;
  final String name;
  final String youtubeCode;

  MentorVideo({
    required this.id,
    required this.name,
    required this.youtubeCode,
  });

  factory MentorVideo.fromJson(Map<String, dynamic> json) {
    return MentorVideo(
      id: json['mvid_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      youtubeCode: json['youtube_code']?.toString() ?? '',
    );
  }

  String get thumbnailUrl => 'https://img.youtube.com/vi/$youtubeCode/hqdefault.jpg';

  String get youtubeUrl => 'https://www.youtube.com/watch?v=$youtubeCode';
}

class HomeSlider {
  final String id;
  final String name;
  final String description;
  final String imageUrl;

  HomeSlider({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
  });

  factory HomeSlider.fromJson(Map<String, dynamic> json) {
    return HomeSlider(
      id: json['sld_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      imageUrl: json['sld_image']?.toString() ?? '',
    );
  }
}

class HomePackage {
  final String id;
  final String name;
  final String label;
  final String oldPrice;
  final String finalPrice;
  final String discount;
  final String standard;
  final String medium;
  final String exam;
  final int totalTests;
  final int totalVideos;
  final String imageUrl;

  HomePackage({
    required this.id,
    required this.name,
    required this.label,
    required this.oldPrice,
    required this.finalPrice,
    required this.discount,
    required this.standard,
    required this.medium,
    required this.exam,
    required this.totalTests,
    required this.totalVideos,
    required this.imageUrl,
  });

  factory HomePackage.fromJson(Map<String, dynamic> json) {
    return HomePackage(
      id: json['pk_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
      oldPrice: json['old_price']?.toString() ?? '',
      finalPrice: json['final_price']?.toString() ?? '',
      discount: json['discount']?.toString() ?? '',
      standard: json['standard']?.toString() ?? '',
      medium: json['medium']?.toString() ?? '',
      exam: json['exam']?.toString() ?? '',
      totalTests: _parseInt(json['total_tests']),
      totalVideos: _parseInt(json['total_video']),
      imageUrl: json['pk_image']?.toString() ?? '',
    );
  }
}

int _parseInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) {
    return int.tryParse(value) ?? 0;
  }
  return 0;
}

