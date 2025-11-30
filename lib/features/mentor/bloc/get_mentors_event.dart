part of 'get_mentors_bloc.dart';

sealed class GetMentorsEvent {}

class FetchMentors extends GetMentorsEvent {
  FetchMentors({required this.subId});

  final String subId;
}

