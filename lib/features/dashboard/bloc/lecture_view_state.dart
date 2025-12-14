part of 'lecture_view_bloc.dart';

sealed class LectureViewState {}

final class LectureViewInitial extends LectureViewState {}

final class LectureViewSuccess extends LectureViewState {
  LectureViewSuccess({required this.message});

  final String message;
}

