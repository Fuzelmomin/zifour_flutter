part of 'course_packages_bloc.dart';

enum CoursePackagesStatus { initial, loading, success, empty, failure }

class CoursePackagesState {
  const CoursePackagesState({
    this.status = CoursePackagesStatus.initial,
    this.packages = const [],
    this.errorMessage,
  });

  final CoursePackagesStatus status;
  final List<CoursePackage> packages;
  final String? errorMessage;

  CoursePackagesState copyWith({
    CoursePackagesStatus? status,
    List<CoursePackage>? packages,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return CoursePackagesState(
      status: status ?? this.status,
      packages: packages ?? this.packages,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }
}


