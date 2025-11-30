part of 'course_packages_bloc.dart';

abstract class CoursePackagesEvent {
  const CoursePackagesEvent();
}

class CoursePackagesRequested extends CoursePackagesEvent {
  const CoursePackagesRequested({
    this.studentId = '13',
    this.mediumId = '1',
    this.examId = '1',
  });

  final String studentId;
  final String mediumId;
  final String examId;
}


