part of 'course_package_details_bloc.dart';

sealed class CoursePackageDetailsEvent {}

class FetchPackageDetails extends CoursePackageDetailsEvent {
  FetchPackageDetails({
    required this.packageId,
    required this.studentId

  });

  final String packageId;
  final String studentId;
}