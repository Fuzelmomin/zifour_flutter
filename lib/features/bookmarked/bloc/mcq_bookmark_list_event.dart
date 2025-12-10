part of 'mcq_bookmark_list_bloc.dart';

abstract class McqBookmarkListEvent {
  const McqBookmarkListEvent();
}

class McqBookmarkListRequested extends McqBookmarkListEvent {
  const McqBookmarkListRequested();
}

class McqBookmarkItemRemoved extends McqBookmarkListEvent {
  final String mcqId;
  const McqBookmarkItemRemoved({required this.mcqId});
}

