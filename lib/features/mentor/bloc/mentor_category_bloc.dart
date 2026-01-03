import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/api_models/api_status.dart';
import '../../../core/api_models/mentor_category_model.dart';
import '../../../core/services/mentor_category_service.dart';
import '../repository/mentor_category_repository.dart';

part 'mentor_category_event.dart';
part 'mentor_category_state.dart';

class MentorCategoryBloc extends Bloc<MentorCategoryEvent, MentorCategoryState> {
  MentorCategoryBloc({MentorCategoryRepository? repository})
      : _repository = repository ?? MentorCategoryRepository(),
        super(MentorCategoryState.initial()) {
    on<MentorCategoryRequested>(_onRequested);
  }

  final MentorCategoryRepository _repository;
  final MentorCategoryService _mentorCategoryService = MentorCategoryService();

  Future<void> _onRequested(
    MentorCategoryRequested event,
    Emitter<MentorCategoryState> emit,
  ) async {
    if (!event.silent) {
      emit(state.copyWith(
        status: MentorCategoryStatus.loading,
        clearError: true,
      ));
    }

    final response = await _repository.fetchMentorCategories();

    if (response.status == ApiStatus.success && response.data != null) {
      final categoryResponse = response.data!;
      
      if (event.updateService) {
        _mentorCategoryService.updateCategories(categoryResponse.mentorCategoryList);
      }
      
      emit(state.copyWith(
        status: MentorCategoryStatus.success,
        data: categoryResponse,
        clearError: true,
      ));
    } else {
      if (!event.silent) {
        emit(state.copyWith(
          status: MentorCategoryStatus.failure,
          errorMessage: response.errorMsg ?? 'Unable to load mentor categories.',
        ));
      }
    }
  }
}
