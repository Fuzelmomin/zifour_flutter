part of 'get_calender_events_bloc.dart';

sealed class GetCalenderEventsState {}

final class GetCalenderEventsInitial extends GetCalenderEventsState {}

final class GetCalenderEventsLoading extends GetCalenderEventsState {}

final class GetCalenderEventsSuccess extends GetCalenderEventsState {
  GetCalenderEventsSuccess({required this.events});

  final List<CalendarEventItem> events;
}

final class GetCalenderEventsError extends GetCalenderEventsState {
  GetCalenderEventsError({required this.message});

  final String message;
}
