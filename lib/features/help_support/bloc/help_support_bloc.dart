import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zifour_sourcecode/core/api_models/api_status.dart';
import 'package:zifour_sourcecode/features/help_support/model/help_support_model.dart';
import 'package:zifour_sourcecode/features/help_support/repository/help_support_repository.dart';

part 'help_support_event.dart';
part 'help_support_state.dart';

class HelpSupportBloc extends Bloc<HelpSupportEvent, HelpSupportState> {
  final HelpSupportRepository _repository;

  HelpSupportBloc({HelpSupportRepository? repository})
      : _repository = repository ?? HelpSupportRepository(),
        super(HelpSupportState.initial()) {
    on<HelpSupportRequested>(_onRequested);
  }

  Future<void> _onRequested(
    HelpSupportRequested event,
    Emitter<HelpSupportState> emit,
  ) async {
    emit(state.copyWith(
      status: HelpSupportStatus.loading,
      clearError: true,
    ));

    final response = await _repository.fetchSupportDetails();

    if (response.status == ApiStatus.success && response.data != null) {
      emit(state.copyWith(
        status: HelpSupportStatus.success,
        data: response.data,
        clearError: true,
      ));
    } else {
      emit(state.copyWith(
        status: HelpSupportStatus.failure,
        errorMessage: response.errorMsg ?? 'Unable to load support details.',
      ));
    }
  }
}
