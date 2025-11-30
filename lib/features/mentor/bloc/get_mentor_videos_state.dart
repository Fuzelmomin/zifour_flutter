part of 'get_mentor_videos_bloc.dart';

sealed class GetMentorVideosState {}

final class GetMentorVideosInitial extends GetMentorVideosState {}

final class GetMentorVideosLoading extends GetMentorVideosState {}

final class GetMentorVideosSuccess extends GetMentorVideosState {
  GetMentorVideosSuccess({required this.videos});

  final List<MentorVideoItem> videos;
}

final class GetMentorVideosError extends GetMentorVideosState {
  GetMentorVideosError({required this.message});

  final String message;
}

