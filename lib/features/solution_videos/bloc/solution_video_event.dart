part of 'solution_video_bloc.dart';

abstract class SolutionVideoEvent {}

class FetchSolutionVideos extends SolutionVideoEvent {
  final String paperId;
  final String subId;

  FetchSolutionVideos({required this.paperId, required this.subId});
}

class FetchExpertSolutionVideos extends SolutionVideoEvent {
  final String challengeId;
  final String subId;

  FetchExpertSolutionVideos({required this.challengeId, required this.subId});
}
