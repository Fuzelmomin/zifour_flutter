import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/api_models/api_status.dart';
import '../model/mentor_videos_model.dart';
import '../repository/get_mentor_videos_repository.dart';

part 'get_mentor_videos_event.dart';
part 'get_mentor_videos_state.dart';

class GetMentorVideosBloc
    extends Bloc<GetMentorVideosEvent, GetMentorVideosState> {
  GetMentorVideosBloc({GetMentorVideosRepository? repository})
      : _repository = repository ?? GetMentorVideosRepository(),
        super(GetMentorVideosInitial()) {
    on<FetchMentorVideos>(_onFetchMentorVideos);
  }

  final GetMentorVideosRepository _repository;

  Future<void> _onFetchMentorVideos(
    FetchMentorVideos event,
    Emitter<GetMentorVideosState> emit,
  ) async {
    emit(GetMentorVideosLoading());

    final response = await _repository.getMentorVideos(mentorId: event.mentorId);

    if (response.status == ApiStatus.success && response.data != null) {
      final videos = response.data!.mtvidList ?? [];
      emit(GetMentorVideosSuccess(videos: videos));
      return;
    }

    emit(
      GetMentorVideosError(
        message: response.errorMsg ?? 'Unable to load videos.',
      ),
    );
  }
}

