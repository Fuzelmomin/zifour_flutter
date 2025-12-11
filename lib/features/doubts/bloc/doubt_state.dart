part of 'doubt_bloc.dart';

abstract class DoubtState {}

class DoubtInitial extends DoubtState {}

class DoubtImageUploading extends DoubtState {}

class DoubtImageUploadSuccess extends DoubtState {
  final String imageUrl;

  DoubtImageUploadSuccess(this.imageUrl);
}

class DoubtImageUploadError extends DoubtState {
  final String message;

  DoubtImageUploadError(this.message);
}

class DoubtSubmitting extends DoubtState {}

class DoubtSubmitSuccess extends DoubtState {
  final String message;

  DoubtSubmitSuccess(this.message);
}

class DoubtSubmitError extends DoubtState {
  final String message;

  DoubtSubmitError(this.message);
}

