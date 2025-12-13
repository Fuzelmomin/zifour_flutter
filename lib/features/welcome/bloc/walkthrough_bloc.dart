import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/api_models/api_status.dart';
import '../model/walkthrough_model.dart';
import '../repository/walkthrough_repository.dart';

part 'walkthrough_event.dart';
part 'walkthrough_state.dart';

class WalkthroughBloc extends Bloc<WalkthroughEvent, WalkthroughState> {
  WalkthroughBloc({WalkthroughRepository? repository})
      : _repository = repository ?? WalkthroughRepository(),
        super(WalkthroughState.initial()) {
    on<WalkthroughRequested>(_onRequested);
  }

  final WalkthroughRepository _repository;

  Future<void> _onRequested(
    WalkthroughRequested event,
    Emitter<WalkthroughState> emit,
  ) async {
    emit(state.copyWith(
      status: WalkthroughStatus.loading,
      clearError: true,
    ));

    final response = await _repository.fetchWalkthrough(
      medId: event.medId,
    );

    if (response.status == ApiStatus.success && response.data != null) {
      emit(state.copyWith(
        status: WalkthroughStatus.success,
        data: response.data,
        clearError: true,
      ));
    } else {
      emit(state.copyWith(
        status: WalkthroughStatus.failure,
        errorMessage: response.errorMsg ?? 'Unable to load walkthrough images.',
      ));
    }
  }
}

