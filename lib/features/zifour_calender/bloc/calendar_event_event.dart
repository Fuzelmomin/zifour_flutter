part of 'calendar_event_bloc.dart';

sealed class CalendarEventEvent {}

class CreateCalendarEvent extends CalendarEventEvent {
  CreateCalendarEvent({
    required this.studentId,
    required this.date,
    required this.time,
    required this.title,
    required this.description,
  });

  final String studentId;
  final String date;
  final String time;
  final String title;
  final String description;
}

