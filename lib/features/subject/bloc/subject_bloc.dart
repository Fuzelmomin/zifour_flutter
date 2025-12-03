import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../../core/api_models/api_status.dart';
import '../../../core/api_models/subject_model.dart';
import '../../../core/services/subject_service.dart';
import '../repository/subject_repository.dart';

part 'subject_event.dart';
part 'subject_state.dart';

class SubjectBloc extends Bloc<SubjectEvent, SubjectState> {
  SubjectBloc({SubjectRepository? repository})
      : _repository = repository ?? SubjectRepository(),
        super(SubjectState.initial()) {
    on<SubjectRequested>(_onRequested);
  }

  final SubjectRepository _repository;
  final SubjectService _subjectService = SubjectService();

  Future<void> _onRequested(
    SubjectRequested event,
    Emitter<SubjectState> emit,
  ) async {
    if (!event.silent) {
      emit(state.copyWith(
        status: SubjectStatus.loading,
        clearError: true,
      ));
    }

    final response = await _repository.fetchSubjects();

    if (response.status == ApiStatus.success && response.data != null) {
      final subjectResponse = response.data!;
      final _logger = Logger();

      _logger.d(subjectResponse);
      _subjectService.updateSubjects(subjectResponse.subjectList);
      
      emit(state.copyWith(
        status: SubjectStatus.success,
        data: subjectResponse,
        clearError: true,
      ));
    } else {
      if (!event.silent) {
        emit(state.copyWith(
          status: SubjectStatus.failure,
          errorMessage: response.errorMsg ?? 'Unable to load subjects.',
        ));
      }
    }
  }
}

