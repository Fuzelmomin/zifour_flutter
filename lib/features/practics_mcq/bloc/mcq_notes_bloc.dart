import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/api_models/api_status.dart';
import '../model/mcq_notes_model.dart';
import '../repository/mcq_notes_repository.dart';

part 'mcq_notes_event.dart';
part 'mcq_notes_state.dart';

class McqNotesBloc extends Bloc<McqNotesEvent, McqNotesState> {
  McqNotesBloc({McqNotesRepository? repository})
      : _repository = repository ?? McqNotesRepository(),
        super(McqNotesState.initial()) {
    on<McqNotesRequested>(_onRequested);
  }

  final McqNotesRepository _repository;

  Future<void> _onRequested(
    McqNotesRequested event,
    Emitter<McqNotesState> emit,
  ) async {
    emit(state.copyWith(
      status: McqNotesStatus.loading,
      clearError: true,
    ));

    final response = await _repository.addMcqNote(
      mcqId: event.mcqId,
      mcqNotesTitle: event.mcqNotesTitle,
      mcqNotesDescription: event.mcqNotesDescription,
    );

    if (response.status == ApiStatus.success && response.data != null) {
      emit(state.copyWith(
        status: McqNotesStatus.success,
        data: response.data,
        clearError: true,
      ));
    } else {
      emit(state.copyWith(
        status: McqNotesStatus.failure,
        errorMessage: response.errorMsg ?? 'Unable to add note.',
      ));
    }
  }
}

