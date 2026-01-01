import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/api_models/api_status.dart';
import '../model/create_challenge_model.dart';
import '../repository/create_challenge_repository.dart';

part 'create_challenge_event.dart';
part 'create_challenge_state.dart';

class CreateChallengeBloc
    extends Bloc<CreateChallengeEvent, CreateChallengeState> {
  CreateChallengeBloc({CreateChallengeRepository? repository})
      : _repository = repository ?? CreateChallengeRepository(),
        super(CreateChallengeState.initial()) {
    on<CreateChallengeRequested>(_onRequested);
  }

  final CreateChallengeRepository _repository;

  Future<void> _onRequested(
    CreateChallengeRequested event,
    Emitter<CreateChallengeState> emit,
  ) async {
    print('CreateChallengeBloc: Event received - chapters: ${event.chapterIds}, topics: ${event.topicIds}, subIds: ${event.subIds}');
    
    emit(state.copyWith(
      status: CreateChallengeStatus.loading,
      clearError: true,
    ));

    print('CreateChallengeBloc: Calling repository.createChallenge()');
    final response = await _repository.createChallenge(
      chapterIds: event.chapterIds,
      topicIds: event.topicIds,
      subIds: event.subIds,
      challengeType: event.challengeType,
    );
    
    print('CreateChallengeBloc: Repository response status: ${response.status}');

    if (response.status == ApiStatus.success && response.data != null) {
      emit(state.copyWith(
        status: CreateChallengeStatus.success,
        data: response.data,
        clearError: true,
      ));
    } else {
      emit(state.copyWith(
        status: CreateChallengeStatus.failure,
        errorMessage: response.errorMsg ?? 'Unable to create challenge.',
      ));
    }
  }
}


