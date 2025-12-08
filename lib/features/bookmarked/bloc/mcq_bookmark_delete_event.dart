part of 'mcq_bookmark_delete_bloc.dart';

abstract class McqBookmarkDeleteEvent {
  const McqBookmarkDeleteEvent();
}

class McqBookmarkDeleteRequested extends McqBookmarkDeleteEvent {
  final String mcqId;

  const McqBookmarkDeleteRequested({
    required this.mcqId,
  });
}

