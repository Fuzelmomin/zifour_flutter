import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/api_models/api_status.dart';
import '../model/mentors_list_model.dart';
import '../repository/get_mentors_repository.dart';

part 'get_mentors_event.dart';
part 'get_mentors_state.dart';

class GetMentorsBloc extends Bloc<GetMentorsEvent, GetMentorsState> {
  GetMentorsBloc({GetMentorsRepository? repository})
      : _repository = repository ?? GetMentorsRepository(),
        super(GetMentorsInitial()) {
    on<FetchMentors>(_onFetchMentors);
  }

  final GetMentorsRepository _repository;

  Future<void> _onFetchMentors(
    FetchMentors event,
    Emitter<GetMentorsState> emit,
  ) async {
    emit(GetMentorsLoading());

    final response = await _repository.getMentors(subId: event.subId);

    if (response.status == ApiStatus.success && response.data != null) {
      final mentors = response.data!.mentorList ?? [];
      emit(GetMentorsSuccess(mentors: mentors));
      return;
    }

    emit(
      GetMentorsError(
        message: response.errorMsg ?? 'Unable to load mentors.',
      ),
    );
  }
}

