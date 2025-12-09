import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/api_models/api_status.dart';
import '../model/challenge_result_model.dart';
import '../repository/challenge_result_repository.dart';

part 'challenge_result_event.dart';
part 'challenge_result_state.dart';

class ChallengeResultBloc
    extends Bloc<ChallengeResultEvent, ChallengeResultState> {
  ChallengeResultBloc({ChallengeResultRepository? repository})
      : _repository = repository ?? ChallengeResultRepository(),
        super(ChallengeResultState.initial()) {
    on<ChallengeResultRequested>(_onRequested);
  }

  final ChallengeResultRepository _repository;

  Future<void> _onRequested(
    ChallengeResultRequested event,
    Emitter<ChallengeResultState> emit,
  ) async {
    print('ChallengeResultBloc: Event received - crtChlId: ${event.crtChlId}');
    
    emit(state.copyWith(
      status: ChallengeResultStatus.loading,
      clearError: true,
    ));

    print('ChallengeResultBloc: Calling repository.getChallengeResult()');
    final response = await _repository.getChallengeResult(
      crtChlId: event.crtChlId,
    );
    
    print('ChallengeResultBloc: Repository response status: ${response.status}');

    if (response.status == ApiStatus.success && response.data != null) {
      emit(state.copyWith(
        status: ChallengeResultStatus.success,
        data: response.data,
        clearError: true,
      ));
    } else {
      emit(state.copyWith(
        status: ChallengeResultStatus.failure,
        errorMessage: response.errorMsg ?? 'Unable to fetch challenge result.',
      ));
    }
  }
}
