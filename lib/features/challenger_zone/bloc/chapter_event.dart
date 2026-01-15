part of 'chapter_bloc.dart';

abstract class ChapterEvent {
  const ChapterEvent();
}

class ChapterRequested extends ChapterEvent {
  final String subId;
  final bool replace; // If true, replace chapters instead of append

  const ChapterRequested({required this.subId, this.replace = false});
}

class ChapterReplaceRequested extends ChapterEvent {
  final List<ChapterModel> chapters;
  final String subId;

  const ChapterReplaceRequested({required this.chapters, required this.subId});
}

class ChapterRemoveRequested extends ChapterEvent {
  final String subId;

  const ChapterRemoveRequested({required this.subId});
}

