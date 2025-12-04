part of 'multimedia_videos_bloc.dart';

abstract class MultimediaVideosState {}

class MultimediaVideosInitial extends MultimediaVideosState {}

class MultimediaVideosLoading extends MultimediaVideosState {}

class MultimediaVideosLoaded extends MultimediaVideosState {
  final MultimediaVideosModel multimediaVideosModel;

  MultimediaVideosLoaded(this.multimediaVideosModel);
}

class MultimediaVideosError extends MultimediaVideosState {
  final String message;

  MultimediaVideosError(this.message);
}
