import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/api_models/api_status.dart';
import '../model/change_course_model.dart';
import '../repository/change_course_repository.dart';

part 'change_course_event.dart';
part 'change_course_state.dart';

class ChangeCourseBloc extends Bloc<ChangeCourseEvent, ChangeCourseState> {
  ChangeCourseBloc({ChangeCourseRepository? repository})
      : _repository = repository ?? ChangeCourseRepository(),
        super(ChangeCourseInitial()) {
    on<ChangeCourseRequested>(_onChangeCourseRequested);
  }

  final ChangeCourseRepository _repository;

  Future<void> _onChangeCourseRequested(
    ChangeCourseRequested event,
    Emitter<ChangeCourseState> emit,
  ) async {
    emit(ChangeCourseLoading());

    final response = await _repository.changeCourse(
      stuId: event.stuId,
      stuStdId: event.stuStdId,
      stuExmId: event.stuExmId,
      stuMedId: event.stuMedId,
      stuSubId: event.stuSubId,
    );

    if (response.status == ApiStatus.success && response.data != null) {
      emit(ChangeCourseSuccess(
        message: response.data!.message,
        isActive: response.data!.isActive,
      ));
      return;
    }

    emit(
      ChangeCourseError(
        message: response.errorMsg ?? 'Unable to change course.',
      ),
    );
  }
}

