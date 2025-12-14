part of 'change_course_bloc.dart';

sealed class ChangeCourseEvent {}

class ChangeCourseRequested extends ChangeCourseEvent {
  ChangeCourseRequested({
    required this.stuId,
    required this.stuStdId,
    required this.stuExmId,
    required this.stuMedId,
    required this.stuSubId,
  });

  final String stuId;
  final String stuStdId;
  final String stuExmId;
  final String stuMedId;
  final String stuSubId;
}

