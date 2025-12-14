part of 'lecture_reminder_bloc.dart';

sealed class LectureReminderState {}

final class LectureReminderInitial extends LectureReminderState {}

final class LectureReminderLoading extends LectureReminderState {}

final class LectureReminderSuccess extends LectureReminderState {
  LectureReminderSuccess({
    required this.reminder,
    required this.message,
  });

  final LectureReminderResponse reminder;
  final String message;
}

final class LectureReminderError extends LectureReminderState {
  LectureReminderError({required this.message});

  final String message;
}

