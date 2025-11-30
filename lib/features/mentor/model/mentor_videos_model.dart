class MentorVideosResponse {
  MentorVideosResponse({
    required this.status,
    required this.message,
    this.mtvidList,
  });

  final bool status;
  final String message;
  final List<MentorVideoItem>? mtvidList;

  factory MentorVideosResponse.fromJson(Map<String, dynamic> json) {
    return MentorVideosResponse(
      status: json['status'] as bool? ?? false,
      message: json['message']?.toString() ?? '',
      mtvidList: json['mtvid_list'] != null
          ? (json['mtvid_list'] as List)
              .map((item) =>
                  MentorVideoItem.fromJson(item as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'mtvid_list': mtvidList?.map((item) => item.toJson()).toList(),
    };
  }
}

class MentorVideoItem {
  MentorVideoItem({
    this.mvidId,
    this.name,
    this.youtubeCode,
  });

  final String? mvidId;
  final String? name;
  final String? youtubeCode;

  factory MentorVideoItem.fromJson(Map<String, dynamic> json) {
    return MentorVideoItem(
      mvidId: json['mvid_id']?.toString(),
      name: json['name']?.toString(),
      youtubeCode: json['youtube_code']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mvid_id': mvidId,
      'name': name,
      'youtube_code': youtubeCode,
    };
  }

  String get thumbnailUrl =>
      'https://img.youtube.com/vi/$youtubeCode/hqdefault.jpg';
}

