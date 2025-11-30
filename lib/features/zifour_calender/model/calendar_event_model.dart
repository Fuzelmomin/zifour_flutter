class CalendarEventResponse {
  CalendarEventResponse({
    required this.status,
    required this.message,
    this.data,
  });

  final bool status;
  final String message;
  final CalendarEventData? data;

  factory CalendarEventResponse.fromJson(Map<String, dynamic> json) {
    return CalendarEventResponse(
      status: json['status'] as bool? ?? false,
      message: json['message']?.toString() ?? '',
      data: json['data'] != null
          ? CalendarEventData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class CalendarEventData {
  CalendarEventData({
    this.calevtTitle,
  });

  final String? calevtTitle;

  factory CalendarEventData.fromJson(Map<String, dynamic> json) {
    return CalendarEventData(
      calevtTitle: json['calevt_title']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'calevt_title': calevtTitle,
    };
  }
}

