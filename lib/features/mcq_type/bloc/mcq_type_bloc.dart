import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../../core/api_models/api_status.dart';
import '../../../core/api_models/mcq_type_model.dart';
import '../../../core/services/mcq_type_service.dart';
import '../repository/mcq_type_repository.dart';

part 'mcq_type_event.dart';
part 'mcq_type_state.dart';

class McqTypeBloc extends Bloc<McqTypeEvent, McqTypeState> {
  McqTypeBloc({McqTypeRepository? repository})
      : _repository = repository ?? McqTypeRepository(),
        super(McqTypeState.initial()) {
    on<McqTypeRequested>(_onRequested);
  }

  final McqTypeRepository _repository;
  final McqTypeService _mcqTypeService = McqTypeService();

  Future<void> _onRequested(
    McqTypeRequested event,
    Emitter<McqTypeState> emit,
  ) async {
    if (!event.silent) {
      emit(state.copyWith(
        status: McqTypeStatus.loading,
        clearError: true,
      ));
    }

    final response = await _repository.fetchMcqTypes();

    if (response.status == ApiStatus.success && response.data != null) {
      final mcqTypeResponse = response.data!;
      final _logger = Logger();

      _logger.d(mcqTypeResponse);
      _mcqTypeService.updateMcqTypes(mcqTypeResponse.mcqTypList);
      
      emit(state.copyWith(
        status: McqTypeStatus.success,
        data: mcqTypeResponse,
        clearError: true,
      ));
    } else {
      if (!event.silent) {
        emit(state.copyWith(
          status: McqTypeStatus.failure,
          errorMessage: response.errorMsg ?? 'Unable to load MCQ types.',
        ));
      }
    }
  }
}
