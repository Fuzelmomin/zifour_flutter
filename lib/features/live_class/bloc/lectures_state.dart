part of 'lectures_bloc.dart';

sealed class LecturesState {}

final class LecturesInitial extends LecturesState {}

final class LecturesLoading extends LecturesState {}

final class LecturesSuccess extends LecturesState {
  LecturesSuccess({
    required this.lectures,
    this.chpTitle,
    this.testBtn,
    this.message,
  });

  final List<LectureItem> lectures;
  final String? chpTitle;
  final int? testBtn;
  final String? message;
}

final class LecturesError extends LecturesState {
  LecturesError({required this.message});

  final String message;
}

