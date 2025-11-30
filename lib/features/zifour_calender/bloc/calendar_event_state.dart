part of 'calendar_event_bloc.dart';

sealed class CalendarEventState {}

final class CalendarEventInitial extends CalendarEventState {}

final class CalendarEventLoading extends CalendarEventState {}

final class CalendarEventSuccess extends CalendarEventState {
  CalendarEventSuccess({required this.message});

  final String message;
}

final class CalendarEventError extends CalendarEventState {
  CalendarEventError({required this.message});

  final String message;
}

