import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/api_models/api_status.dart';
import '../model/mcq_notes_delete_model.dart';
import '../repository/mcq_notes_delete_repository.dart';

part 'mcq_notes_delete_event.dart';
part 'mcq_notes_delete_state.dart';

class McqNotesDeleteBloc
    extends Bloc<McqNotesDeleteEvent, McqNotesDeleteState> {
  McqNotesDeleteBloc({McqNotesDeleteRepository? repository})
      : _repository = repository ?? McqNotesDeleteRepository(),
        super(McqNotesDeleteState.initial()) {
    on<McqNotesDeleteRequested>(_onRequested);
  }

  final McqNotesDeleteRepository _repository;

  Future<void> _onRequested(
    McqNotesDeleteRequested event,
    Emitter<McqNotesDeleteState> emit,
  ) async {
    emit(state.copyWith(
      status: McqNotesDeleteStatus.loading,
      clearError: true,
    ));

    final response = await _repository.deleteMcqNote(
      mcqId: event.mcqId,
    );

    if (response.status == ApiStatus.success && response.data != null) {
      emit(state.copyWith(
        status: McqNotesDeleteStatus.success,
        data: response.data,
        clearError: true,
      ));
    } else {
      emit(state.copyWith(
        status: McqNotesDeleteStatus.failure,
        errorMessage: response.errorMsg ?? 'Unable to delete note.',
      ));
    }
  }
}

