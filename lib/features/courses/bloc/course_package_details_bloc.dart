import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/api_models/api_status.dart';
import '../models/course_details_model.dart';
import '../repository/course_package_details_repository.dart';

part 'course_package_details_event.dart';
part 'course_package_details_state.dart';

class CoursePackageDetailsBloc
    extends Bloc<CoursePackageDetailsEvent, CoursePackageDetailsState> {
  CoursePackageDetailsBloc({CoursePackageDetailsRepository? repository})
      : _repository = repository ?? CoursePackageDetailsRepository(),
        super(CoursePackageDetailsInitial()) {
    on<FetchPackageDetails>(_onFetchPackageDetails);
  }

  final CoursePackageDetailsRepository _repository;

  Future<void> _onFetchPackageDetails(
    FetchPackageDetails event,
    Emitter<CoursePackageDetailsState> emit,
  ) async {
    emit(CoursePackageDetailsLoading());

    final response = await _repository.fetchPackageDetails(
      packageId: event.packageId,
      //studentId: event.studentId,
      studentId: '6',
    );

    if (response.status == ApiStatus.success && response.data != null) {
      emit(CoursePackageDetailsSuccess(packageDetails: response.data!));
      return;
    }

    emit(
      CoursePackageDetailsError(
        message: response.errorMsg ?? 'Unable to load package details.',
      ),
    );
  }
}
