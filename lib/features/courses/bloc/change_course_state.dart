part of 'change_course_bloc.dart';

sealed class ChangeCourseState {}

final class ChangeCourseInitial extends ChangeCourseState {}

final class ChangeCourseLoading extends ChangeCourseState {}

final class ChangeCourseSuccess extends ChangeCourseState {
  ChangeCourseSuccess({
    required this.message,
    required this.isActive,
  });

  final String message;
  final bool isActive;
}

final class ChangeCourseError extends ChangeCourseState {
  ChangeCourseError({required this.message});

  final String message;
}

