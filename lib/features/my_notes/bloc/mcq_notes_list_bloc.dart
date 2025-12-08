import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/api_models/api_status.dart';
import '../model/mcq_notes_list_model.dart';
import '../repository/mcq_notes_list_repository.dart';

part 'mcq_notes_list_event.dart';
part 'mcq_notes_list_state.dart';

class McqNotesListBloc extends Bloc<McqNotesListEvent, McqNotesListState> {
  McqNotesListBloc({McqNotesListRepository? repository})
      : _repository = repository ?? McqNotesListRepository(),
        super(McqNotesListState.initial()) {
    on<McqNotesListRequested>(_onRequested);
  }

  final McqNotesListRepository _repository;

  Future<void> _onRequested(
    McqNotesListRequested event,
    Emitter<McqNotesListState> emit,
  ) async {
    emit(state.copyWith(
      status: McqNotesListStatus.loading,
      clearError: true,
    ));

    final response = await _repository.getMcqNotesList();

    if (response.status == ApiStatus.success && response.data != null) {
      emit(state.copyWith(
        status: McqNotesListStatus.success,
        data: response.data,
        clearError: true,
      ));
    } else {
      emit(state.copyWith(
        status: McqNotesListStatus.failure,
        errorMessage: response.errorMsg ?? 'Unable to load notes.',
      ));
    }
  }
}

