part of 'multimedia_videos_bloc.dart';

abstract class MultimediaVideosEvent {}

class FetchMultimediaVideos extends MultimediaVideosEvent {
  final String mulibId;

  FetchMultimediaVideos({required this.mulibId});
}
