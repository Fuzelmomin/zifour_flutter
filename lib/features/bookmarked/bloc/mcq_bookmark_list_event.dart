part of 'mcq_bookmark_list_bloc.dart';

abstract class McqBookmarkListEvent {
  const McqBookmarkListEvent();
}

class McqBookmarkListRequested extends McqBookmarkListEvent {
  const McqBookmarkListRequested();
}

