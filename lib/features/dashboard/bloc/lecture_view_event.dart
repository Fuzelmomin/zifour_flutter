part of 'lecture_view_bloc.dart';

sealed class LectureViewEvent {}

class MarkLectureAsViewed extends LectureViewEvent {
  MarkLectureAsViewed({
    required this.lecId,
    this.stuId,
  });

  final String lecId;
  final String? stuId;
}

