class LectureReminderResponse {
  LectureReminderResponse({
    required this.status,
    required this.message,
    this.reminderId,
    this.stuId,
    this.lecId,
    this.reminderDate,
  });

  final bool status;
  final String message;
  final int? reminderId;
  final String? stuId;
  final String? lecId;
  final String? reminderDate;

  factory LectureReminderResponse.fromJson(Map<String, dynamic> json) {
    return LectureReminderResponse(
      status: json['status'] as bool? ?? false,
      message: json['message']?.toString() ?? '',
      reminderId: json['reminder_id'] as int?,
      stuId: json['stu_id']?.toString(),
      lecId: json['lec_id']?.toString(),
      reminderDate: json['reminder_date']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'reminder_id': reminderId,
      'stu_id': stuId,
      'lec_id': lecId,
      'reminder_date': reminderDate,
    };
  }
}

