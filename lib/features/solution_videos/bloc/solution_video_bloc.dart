import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/api_models/api_status.dart';
import '../model/solution_video_model.dart';
import '../repository/solution_video_repository.dart';

part 'solution_video_event.dart';
part 'solution_video_state.dart';

class SolutionVideoBloc extends Bloc<SolutionVideoEvent, SolutionVideoState> {
  SolutionVideoBloc({SolutionVideoRepository? repository})
      : _repository = repository ?? SolutionVideoRepository(),
        super(SolutionVideoInitial()) {
    on<FetchSolutionVideos>(_onFetchSolutionVideos);
    on<FetchExpertSolutionVideos>(_onFetchExpertSolutionVideos);
  }

  final SolutionVideoRepository _repository;

  Future<void> _onFetchSolutionVideos(
    FetchSolutionVideos event,
    Emitter<SolutionVideoState> emit,
  ) async {
    emit(SolutionVideoLoading());

    final response = await _repository.fetchSolutionVideos(
      paperId: event.paperId,
      subId: event.subId,
    );

    if (response.status == ApiStatus.success && response.data != null) {
      final videos = response.data!.solutionList;
      emit(SolutionVideoSuccess(solutionVideos: videos));
      return;
    }

    emit(
      SolutionVideoError(
        message: response.errorMsg ?? 'Unable to load solution videos.',
      ),
    );
  }

  Future<void> _onFetchExpertSolutionVideos(
    FetchExpertSolutionVideos event,
    Emitter<SolutionVideoState> emit,
  ) async {
    emit(SolutionVideoLoading());

    final response = await _repository.fetchExpertSolutionVideos(
      challengeId: event.challengeId,
      subId: event.subId,
    );

    if (response.status == ApiStatus.success && response.data != null) {
      final videos = response.data!.solutionList.map((e) => SolutionVideoModel(
        gSlId: e.crtChSlId,
        solutionVideo: e.solutionVideo,
      )).toList();
      emit(SolutionVideoSuccess(solutionVideos: videos));
      return;
    }

    emit(
      SolutionVideoError(
        message: response.errorMsg ?? 'Unable to load expert solution videos.',
      ),
    );
  }
}
