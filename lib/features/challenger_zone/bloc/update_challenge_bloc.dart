import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/api_models/api_status.dart';
import '../model/update_challenge_model.dart';
import '../repository/update_challenge_repository.dart';

part 'update_challenge_event.dart';
part 'update_challenge_state.dart';

class UpdateChallengeBloc
    extends Bloc<UpdateChallengeEvent, UpdateChallengeState> {
  UpdateChallengeBloc({UpdateChallengeRepository? repository})
      : _repository = repository ?? UpdateChallengeRepository(),
        super(UpdateChallengeState.initial()) {
    on<UpdateChallengeRequested>(_onRequested);
  }

  final UpdateChallengeRepository _repository;

  Future<void> _onRequested(
    UpdateChallengeRequested event,
    Emitter<UpdateChallengeState> emit,
  ) async {
    emit(state.copyWith(
      status: UpdateChallengeStatus.loading,
      clearError: true,
    ));

    final response = await _repository.updateChallenge(
      crtChlId: event.crtChlId,
      chapterIds: event.chapterIds,
      topicIds: event.topicIds,
      subId: event.subId,
    );

    if (response.status == ApiStatus.success && response.data != null) {
      emit(state.copyWith(
        status: UpdateChallengeStatus.success,
        data: response.data,
        clearError: true,
      ));
    } else {
      emit(state.copyWith(
        status: UpdateChallengeStatus.failure,
        errorMessage: response.errorMsg ?? 'Unable to update challenge.',
      ));
    }
  }
}

