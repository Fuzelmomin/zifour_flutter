import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/api_models/api_status.dart';
import '../model/challenges_list_model.dart';
import '../repository/challenges_list_repository.dart';

part 'challenges_list_event.dart';
part 'challenges_list_state.dart';

class ChallengesListBloc
    extends Bloc<ChallengesListEvent, ChallengesListState> {
  ChallengesListBloc({ChallengesListRepository? repository})
      : _repository = repository ?? ChallengesListRepository(),
        super(ChallengesListState.initial()) {
    on<ChallengesListRequested>(_onRequested);
  }

  final ChallengesListRepository _repository;

  Future<void> _onRequested(
    ChallengesListRequested event,
    Emitter<ChallengesListState> emit,
  ) async {
    emit(state.copyWith(
      status: ChallengesListStatus.loading,
      clearError: true,
    ));

    final response = await _repository.fetchChallengesList();

    if (response.status == ApiStatus.success && response.data != null) {
      emit(state.copyWith(
        status: ChallengesListStatus.success,
        data: response.data,
        clearError: true,
      ));
    } else {
      emit(state.copyWith(
        status: ChallengesListStatus.failure,
        errorMessage: response.errorMsg ?? 'Unable to load challenges.',
      ));
    }
  }
}

