import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zifour_sourcecode/features/multimedia_library/model/multimedia_library_model.dart';
import 'package:zifour_sourcecode/features/multimedia_library/repository/multimedia_library_repository.dart';

part 'multimedia_library_event.dart';
part 'multimedia_library_state.dart';

class MultimediaLibraryBloc extends Bloc<MultimediaLibraryEvent, MultimediaLibraryState> {
  final MultimediaLibraryRepository repository;

  MultimediaLibraryBloc(this.repository) : super(MultimediaLibraryInitial()) {
    on<FetchMultimediaLibrary>((event, emit) async {
      emit(MultimediaLibraryLoading());
      try {
        final response = await repository.fetchMultimediaLibrary();
        if (response.status == true) {
          emit(MultimediaLibraryLoaded(response));
        } else {
          emit(MultimediaLibraryError(response.message ?? 'Unknown error'));
        }
      } catch (e) {
        emit(MultimediaLibraryError(e.toString()));
      }
    });
  }
}
