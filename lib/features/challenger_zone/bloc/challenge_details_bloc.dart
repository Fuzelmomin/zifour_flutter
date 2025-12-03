import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/api_models/api_status.dart';
import '../model/challenge_details_model.dart';
import '../repository/challenge_details_repository.dart';

part 'challenge_details_event.dart';
part 'challenge_details_state.dart';

class ChallengeDetailsBloc
    extends Bloc<ChallengeDetailsEvent, ChallengeDetailsState> {
  ChallengeDetailsBloc({ChallengeDetailsRepository? repository})
      : _repository = repository ?? ChallengeDetailsRepository(),
        super(ChallengeDetailsState.initial()) {
    on<ChallengeDetailsRequested>(_onRequested);
  }

  final ChallengeDetailsRepository _repository;

  Future<void> _onRequested(
    ChallengeDetailsRequested event,
    Emitter<ChallengeDetailsState> emit,
  ) async {
    emit(state.copyWith(
      status: ChallengeDetailsStatus.loading,
      clearError: true,
    ));

    final response =
        await _repository.fetchChallengeDetails(crtChlId: event.crtChlId);

    if (response.status == ApiStatus.success && response.data != null) {
      emit(state.copyWith(
        status: ChallengeDetailsStatus.success,
        data: response.data,
        clearError: true,
      ));
    } else {
      emit(state.copyWith(
        status: ChallengeDetailsStatus.failure,
        errorMessage:
            response.errorMsg ?? 'Unable to load challenge details.',
      ));
    }
  }
}


