import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/api_models/api_status.dart';
import '../model/revision_model.dart';
import '../repository/revision_repository.dart';

part 'revision_event.dart';
part 'revision_state.dart';

class RevisionBloc extends Bloc<RevisionEvent, RevisionState> {
  final RevisionRepository _repository;

  RevisionBloc({RevisionRepository? repository})
      : _repository = repository ?? RevisionRepository(),
        super(RevisionState.initial()) {
    on<RevisionListRequested>(_onListRequested);
    on<RevisionItemDeleted>(_onItemDeleted);
    on<RevisionSubmitted>(_onSubmitted);
  }

  Future<void> _onListRequested(
    RevisionListRequested event,
    Emitter<RevisionState> emit,
  ) async {
    if (state.status != RevisionStatus.success || event.forceRefresh) {
      emit(state.copyWith(status: RevisionStatus.loading, clearError: true));
    }

    final response = await _repository.fetchRevisionList();

    if (response.status == ApiStatus.success && response.data != null) {
      emit(state.copyWith(
        status: RevisionStatus.success,
        data: response.data,
        clearError: true,
      ));
    } else {
      emit(state.copyWith(
        status: RevisionStatus.failure,
        errorMessage: response.errorMsg ?? 'Unable to fetch revision list.',
      ));
    }
  }

  Future<void> _onItemDeleted(
    RevisionItemDeleted event,
    Emitter<RevisionState> emit,
  ) async {
    emit(state.copyWith(status: RevisionStatus.deleting));

    final response = await _repository.deleteRevision(event.plnrId);

    if (response.status == ApiStatus.success && response.data == true) {
      // Refresh list locally or via API
      emit(state.copyWith(
        status: RevisionStatus.deleteSuccess,
        deleteMessage: 'Revision deleted successfully.',
      ));
      add(const RevisionListRequested(forceRefresh: true));
    } else {
      emit(state.copyWith(
        status: RevisionStatus.deleteFailure,
        errorMessage: response.errorMsg ?? 'Unable to delete revision.',
      ));
    }
  }

  Future<void> _onSubmitted(
    RevisionSubmitted event,
    Emitter<RevisionState> emit,
  ) async {
    emit(state.copyWith(status: RevisionStatus.submitting, clearError: true));

    final response = await _repository.submitRevision(
      stdId: event.stdId,
      exmId: event.exmId,
      subId: event.subId,
      medId: event.medId,
      chpId: event.chpId,
      tpcId: event.tpcId,
      sDate: event.sDate,
      eDate: event.eDate,
      dHours: event.dHours,
      message: event.message,
    );

    if (response.status == ApiStatus.success) {
      emit(state.copyWith(
        status: RevisionStatus.submitSuccess,
        deleteMessage: response.data ?? 'Revision submitted successfully.',
      ));
    } else {
      emit(state.copyWith(
        status: RevisionStatus.submitFailure,
        errorMessage: response.errorMsg ?? 'Unable to submit revision.',
      ));
    }
  }
}
