class DeleteCalendarEventResponse {
  DeleteCalendarEventResponse({
    required this.status,
    required this.message,
  });

  final bool status;
  final String message;

  factory DeleteCalendarEventResponse.fromJson(Map<String, dynamic> json) {
    return DeleteCalendarEventResponse(
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
