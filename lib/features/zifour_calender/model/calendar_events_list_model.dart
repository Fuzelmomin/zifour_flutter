class CalendarEventsListResponse {
  CalendarEventsListResponse({
    required this.status,
    required this.message,
    this.calevtList,
  });

  final bool status;
  final String message;
  final List<CalendarEventItem>? calevtList;

  factory CalendarEventsListResponse.fromJson(Map<String, dynamic> json) {
    return CalendarEventsListResponse(
      status: json['status'] as bool? ?? false,
      message: json['message']?.toString() ?? '',
      calevtList: json['calevt_list'] != null
          ? (json['calevt_list'] as List)
              .map((item) => CalendarEventItem.fromJson(
                  item as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'calevt_list': calevtList?.map((item) => item.toJson()).toList(),
    };
  }
}

class CalendarEventItem {
  CalendarEventItem({
    this.calevtId,
    this.name,
    this.date,
    this.time,
    this.description,
  });

  final String? calevtId;
  final String? name;
  final String? date;
  final String? time;
  final String? description;

  factory CalendarEventItem.fromJson(Map<String, dynamic> json) {
    return CalendarEventItem(
      calevtId: json['calevt_id']?.toString(),
      name: json['name']?.toString(),
      date: json['date']?.toString(),
      time: json['time']?.toString(),
      description: json['description']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'calevt_id': calevtId,
      'name': name,
      'date': date,
      'time': time,
      'description': description,
    };
  }
}

