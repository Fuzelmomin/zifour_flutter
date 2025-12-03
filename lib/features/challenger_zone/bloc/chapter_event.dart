part of 'chapter_bloc.dart';

abstract class ChapterEvent {
  const ChapterEvent();
}

class ChapterRequested extends ChapterEvent {
  final String subId;

  const ChapterRequested({required this.subId});
}

