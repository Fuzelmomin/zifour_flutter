import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/api_models/api_status.dart';
import '../model/mcq_feedback_model.dart';
import '../repository/mcq_feedback_repository.dart';

part 'mcq_feedback_event.dart';
part 'mcq_feedback_state.dart';

class McqFeedbackBloc extends Bloc<McqFeedbackEvent, McqFeedbackState> {
  McqFeedbackBloc({McqFeedbackRepository? repository})
      : _repository = repository ?? McqFeedbackRepository(),
        super(McqFeedbackState.initial()) {
    on<McqFeedbackRequested>(_onRequested);
  }

  final McqFeedbackRepository _repository;

  Future<void> _onRequested(
    McqFeedbackRequested event,
    Emitter<McqFeedbackState> emit,
  ) async {
    emit(state.copyWith(
      status: McqFeedbackStatus.loading,
      clearError: true,
    ));

    final response = await _repository.addMcqFeedback(
      mcqId: event.mcqId,
      mcqType: event.mcqType,
      mcqFdbTitle: event.mcqFdbTitle,
      mcqFdbDescription: event.mcqFdbDescription,
    );

    if (response.status == ApiStatus.success && response.data != null) {
      emit(state.copyWith(
        status: McqFeedbackStatus.success,
        data: response.data,
        clearError: true,
      ));
    } else {
      emit(state.copyWith(
        status: McqFeedbackStatus.failure,
        errorMessage: response.errorMsg ?? 'Unable to add feedback.',
      ));
    }
  }
}
