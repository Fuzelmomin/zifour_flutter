import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zifour_sourcecode/features/multimedia_library/model/multimedia_videos_model.dart';
import 'package:zifour_sourcecode/features/multimedia_library/repository/multimedia_videos_repository.dart';

part 'multimedia_videos_event.dart';
part 'multimedia_videos_state.dart';

class MultimediaVideosBloc extends Bloc<MultimediaVideosEvent, MultimediaVideosState> {
  final MultimediaVideosRepository repository;

  MultimediaVideosBloc(this.repository) : super(MultimediaVideosInitial()) {
    on<FetchMultimediaVideos>((event, emit) async {
      emit(MultimediaVideosLoading());
      try {
        final response = await repository.fetchMultimediaVideos(event.mulibId);
        if (response.status == true) {
          emit(MultimediaVideosLoaded(response));
        } else {
          emit(MultimediaVideosError(response.message ?? 'Unknown error'));
        }
      } catch (e) {
        emit(MultimediaVideosError(e.toString()));
      }
    });
  }
}
