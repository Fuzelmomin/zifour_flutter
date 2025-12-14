class LectureViewResponse {
  LectureViewResponse({
    required this.status,
    required this.message,
  });

  final bool status;
  final String message;

  factory LectureViewResponse.fromJson(Map<String, dynamic> json) {
    return LectureViewResponse(
      status: json['status'] as bool? ?? false,
      message: json['message']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
    };
  }
}

