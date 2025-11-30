part of 'get_calender_events_bloc.dart';

sealed class GetCalenderEventsEvent {}

class FetchCalenderEvents extends GetCalenderEventsEvent {
  FetchCalenderEvents({required this.studentId});

  final String studentId;
}
