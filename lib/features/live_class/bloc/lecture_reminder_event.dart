part of 'lecture_reminder_bloc.dart';

sealed class LectureReminderEvent {}

class AddLectureReminder extends LectureReminderEvent {
  AddLectureReminder({
    required this.lecId,
    required this.reminderDate,
    this.stuId,
  });

  final String lecId;
  final String reminderDate;
  final String? stuId;
}

