part of 'get_mentor_videos_bloc.dart';

sealed class GetMentorVideosEvent {}

class FetchMentorVideos extends GetMentorVideosEvent {
  FetchMentorVideos({required this.mentorId, this.isZMentor});

  final String mentorId;
  final bool? isZMentor;
}

