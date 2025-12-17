part of 'mcq_bookmark_bloc.dart';

abstract class McqBookmarkEvent {
  const McqBookmarkEvent();
}

class McqBookmarkRequested extends McqBookmarkEvent {
  final String mcqId;
  final String mcqType;

  const McqBookmarkRequested({
    required this.mcqId,
    required this.mcqType,
  });
}

