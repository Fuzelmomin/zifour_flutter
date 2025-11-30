import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/api_models/api_status.dart';
import '../models/course_package.dart';
import '../repository/course_package_repository.dart';

part 'course_packages_event.dart';
part 'course_packages_state.dart';

class CoursePackagesBloc
    extends Bloc<CoursePackagesEvent, CoursePackagesState> {
  CoursePackagesBloc({CoursePackageRepository? repository})
      : _repository = repository ?? CoursePackageRepository(),
        super(const CoursePackagesState()) {
    on<CoursePackagesRequested>(_onPackagesRequested);
  }

  final CoursePackageRepository _repository;

  Future<void> _onPackagesRequested(
    CoursePackagesRequested event,
    Emitter<CoursePackagesState> emit,
  ) async {
    emit(
      state.copyWith(
        status: CoursePackagesStatus.loading,
        clearErrorMessage: true,
      ),
    );

    final response = await _repository.fetchPackages(
      // studentId: event.studentId,
      // mediumId: event.mediumId,
      // examId: event.examId,
      studentId: '6',
      mediumId: '1',
      examId: '1',
    );

    if (response.status == ApiStatus.success && response.data != null) {
      final packages = response.data!;
      emit(
        state.copyWith(
          status: packages.isEmpty
              ? CoursePackagesStatus.empty
              : CoursePackagesStatus.success,
          packages: packages,
          clearErrorMessage: true,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: CoursePackagesStatus.failure,
        errorMessage: response.errorMsg ?? 'Unable to load packages.',
      ),
    );
  }
}


