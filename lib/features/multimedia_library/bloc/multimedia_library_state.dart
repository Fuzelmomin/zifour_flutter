part of 'multimedia_library_bloc.dart';

abstract class MultimediaLibraryState {}

class MultimediaLibraryInitial extends MultimediaLibraryState {}

class MultimediaLibraryLoading extends MultimediaLibraryState {}

class MultimediaLibraryLoaded extends MultimediaLibraryState {
  final MultimediaLibraryModel multimediaLibraryModel;

  MultimediaLibraryLoaded(this.multimediaLibraryModel);
}

class MultimediaLibraryError extends MultimediaLibraryState {
  final String message;

  MultimediaLibraryError(this.message);
}
