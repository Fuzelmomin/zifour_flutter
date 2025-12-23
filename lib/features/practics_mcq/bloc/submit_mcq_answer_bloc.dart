import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/api_models/api_status.dart';
import '../model/submit_mcq_answer_model.dart';
import '../repository/submit_mcq_answer_repository.dart';

part 'submit_mcq_answer_event.dart';
part 'submit_mcq_answer_state.dart';

class SubmitMcqAnswerBloc
    extends Bloc<SubmitMcqAnswerEvent, SubmitMcqAnswerState> {
  SubmitMcqAnswerBloc({SubmitMcqAnswerRepository? repository})
      : _repository = repository ?? SubmitMcqAnswerRepository(),
        super(SubmitMcqAnswerState.initial()) {
    on<SubmitMcqAnswerRequested>(_onRequested);
  }

  final SubmitMcqAnswerRepository _repository;

  Future<void> _onRequested(
    SubmitMcqAnswerRequested event,
    Emitter<SubmitMcqAnswerState> emit,
  ) async {
    emit(state.copyWith(
      status: SubmitMcqAnswerStatus.loading,
      clearError: true,
    ));

    final response = await _repository.submitMcqAnswer(
      crtChlId: event.crtChlId,
      mcqList: event.mcqList,
      apiType: event.apiType,
      tpcId: event.tpcId,
      pkId: event.pkId,
      paperId: event.paperId,
    );

    if (response.status == ApiStatus.success && response.data != null) {
      emit(state.copyWith(
        status: SubmitMcqAnswerStatus.success,
        data: response.data,
        clearError: true,
      ));
    } else {
      emit(state.copyWith(
        status: SubmitMcqAnswerStatus.failure,
        errorMessage: response.errorMsg ?? 'Unable to submit answers.',
      ));
    }
  }
}

