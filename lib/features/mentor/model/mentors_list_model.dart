class MentorsListResponse {
  MentorsListResponse({
    required this.status,
    required this.message,
    this.mentorList,
  });

  final bool status;
  final String message;
  final List<MentorItem>? mentorList;

  factory MentorsListResponse.fromJson(Map<String, dynamic> json) {
    return MentorsListResponse(
      status: json['status'] as bool? ?? false,
      message: json['message']?.toString() ?? '',
      mentorList: json['mentor_list'] != null
          ? (json['mentor_list'] as List)
              .map((item) => MentorItem.fromJson(item as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'mentor_list': mentorList?.map((item) => item.toJson()).toList(),
    };
  }
}

class MentorItem {
  MentorItem({
    this.mtrId,
    this.name,
    this.description,
    this.mtrImage,
  });

  final String? mtrId;
  final String? name;
  final String? description;
  final String? mtrImage;

  factory MentorItem.fromJson(Map<String, dynamic> json) {
    return MentorItem(
      mtrId: json['mtr_id']?.toString(),
      name: json['name']?.toString(),
      description: json['description']?.toString(),
      mtrImage: json['mtr_image']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mtr_id': mtrId,
      'name': name,
      'description': description,
      'mtr_image': mtrImage,
    };
  }
}

