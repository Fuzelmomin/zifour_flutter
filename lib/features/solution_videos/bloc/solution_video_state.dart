part of 'solution_video_bloc.dart';

abstract class SolutionVideoState {}

class SolutionVideoInitial extends SolutionVideoState {}

class SolutionVideoLoading extends SolutionVideoState {}

class SolutionVideoSuccess extends SolutionVideoState {
  final List<SolutionVideoModel> solutionVideos;

  SolutionVideoSuccess({required this.solutionVideos});
}

class SolutionVideoError extends SolutionVideoState {
  final String message;

  SolutionVideoError({required this.message});
}
