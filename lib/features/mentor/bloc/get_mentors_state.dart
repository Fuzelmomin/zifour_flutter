part of 'get_mentors_bloc.dart';

sealed class GetMentorsState {}

final class GetMentorsInitial extends GetMentorsState {}

final class GetMentorsLoading extends GetMentorsState {}

final class GetMentorsSuccess extends GetMentorsState {
  GetMentorsSuccess({required this.mentors});

  final List<MentorItem> mentors;
}

final class GetMentorsError extends GetMentorsState {
  GetMentorsError({required this.message});

  final String message;
}

