part of 'course_package_details_bloc.dart';

sealed class CoursePackageDetailsState {}

final class CoursePackageDetailsInitial extends CoursePackageDetailsState {}

final class CoursePackageDetailsLoading extends CoursePackageDetailsState {}

final class CoursePackageDetailsSuccess extends CoursePackageDetailsState {
  CoursePackageDetailsSuccess({required this.packageDetails});

  final PackageDetailsItem packageDetails;
}

final class CoursePackageDetailsError extends CoursePackageDetailsState {
  CoursePackageDetailsError({required this.message});

  final String message;
}